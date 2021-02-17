#!/usr/local/bin/perl

# inspired by https://stackoverflow.com/a/13234597
# and heavily uses PPi, see https://metacpan.org/pod/PPI

#
# known bugs:
#
# use AthenaSecurity::Crypter, is actually used in a Moosey attribute string, `Must[AthenaSecurity::Crypter]`
# use AthenaSecurity::KeyStore::HardCoded::ImportWizard, exports new
# Athena::Entity::Clinical::Provider is an object
# handle import symbols like :foo
# we don't handle turning $foo into $Global::foo (i think it currently tries Global::$Foo)
# it doesn't handle variables inside double-quoted strings. PPI doesn't notice them. this is tough.
# Athena::ServiceBus::Dispatcher should be handled specially to succeed if there are any BusCall::'s
# cases where a sub is imported, but used with the full package name, should be a partial success
#

use Athena::Lib;
use Athena::Policy;
use feature 'say';

use Data::Dumper;
use List::MoreUtils qw( any );
use PPI;
use Readonly;
use Term::ANSIColor qw( colored );

# first, some globals

# these variables are names that are built into perl
Readonly my %PERL_KEYWORDS => map {$_=> 1}
	qw( and cmp continue CORE do else elsif eq exp for foreach ge gt if le lock lt
	m ne no or package q qq qr qw qx s sub tr unless until while xor y );
Readonly my %PERL_BUILTINS => map {$_=> 1}
	qw( abs accept alarm atan2 AUTOLOAD BEGIN bind binmode bless break caller chdir
	CHECK chmod chomp chop chown chr chroot close closedir connect cos crypt
	dbmclose dbmopen defined delete DESTROY die dump each END endgrent endhostent
	endnetent endprotoent endpwent endservent eof eval exec exists exit fcntl
	fileno flock fork format formline getc getgrent getgrgid getgrnam gethostbyaddr
	gethostbyname gethostent getlogin getnetbyaddr getnetbyname getnetent
	getpeername getpgrp getppid getpriority getprotobyname getprotobynumber
	getprotoent getpwent getpwnam getpwuid getservbyname getservbyport getservent
	getsockname getsockopt glob gmtime goto grep hex index INIT int ioctl join keys
	kill last lc lcfirstlength link listen local localtime log lstat map mkdir
	msgctl msgget msgrcv msgsnd my next not oct open opendir ord our pack pipe pop
	pos print printf prototype push quotemeta rand read readdir readline readlink
	readpipe recv redo ref rename require reset return reverse rewinddir rindex
	rmdir say scalar seek seekdir select semctl semget semop send setgrent
	sethostent setnetent setpgrp setpriority setprotoent setpwent setservent
	setsockopt shift shmctl shmget shmread shmwrite shutdown sin sleep socket
	socketpair sort splice split sprintf sqrt srand stat state study substr symlink
	syscall sysopen sysread sysseek system syswrite tell telldir tie tied time
	times truncate uc ucfirst umask undef UNITCHECK unlink unpack unshift untie use
	utime values vec wait waitpid wantarray warn write );
Readonly my %PERL_PRAGMAS => map {$_=> 1}
	qw( arybase attributes autodie autodie::exception autodie::exception::system
	autodie::hints autodie::skip autouse base bigint bignum bigrat blib bytes
	charnames constant deprecate diagnostics encoding encoding::warnings
	experimental feature fields filetest if integer less lib locale mro ok open
	ops overload overloading parent re sigtrap sort strict subs threads
	threads::shared utf8 vars version vmsish warnings warnings::register );

my $debug = 0;
my $indentstring = "\t";

# check command line options
die "usage: $0 <filename>\n" unless $ARGV[0];
$debug = 1 if $ARGV[1] eq '-d';

main($ARGV[0]);

exit;

# our main subroutine does four things:
# 1) get a list of included packages in the file (use or require)
# 2) for each include, see which things (subs, constants, and global variables) it has
# 3) in the original file, get a list of things it uses
# 4) match the list from 2 and 3 to see which included packages are being used, and how
sub main {
	my $filename = shift;

	# skip if we won't want to look at this file
	return unless -e $filename;

	my $ppi_doc = PPI::Document->new($filename);

	say "$filename" if $debug;

	# step 1) get the include statements in the file, and load them into variables
	my ($manual_includes, $general_includes) = get_included_modules($ppi_doc);

	# step 2) get list of available names from each include without a manual include list
	# TODO: step 2.1) get list of available names from each module *with* an manual include list
	foreach my $module (keys %$general_includes) {
		$general_includes->{$module} = find_names_declared_in_module($module);
	}
	foreach my $module (keys %$manual_includes) {
		my @subs = map {"${module}::$_"} @{find_names_declared_in_module($module)};
		push @{$manual_includes->{$module}}, @subs;
	}

	# step 3) get a list of all names in our file
	my $names = names_used_in_document($ppi_doc);

	#say Dumper($manual_includes);
	#say Dumper($general_includes);
	#say Dumper($names);

	# step 4) check the names we use in our file against the names we found in our
	# included files, and print out how each included file is used.
	say "starting analysis" if $debug;
	check_general_includes($names, $general_includes);
	check_manual_includes($names, $manual_includes);
}

# given a PPI document, it gets all included statements in the file.
# it looks for two types of includes, ones with an explicit list of names in import, and ones without
# it returns two hashrefs, representing both types
sub get_included_modules {
	my ($ppi_doc) = @_;

	my (%manual_includes, %general_includes);

	foreach my $x (@{$ppi_doc->find("PPI::Statement::Include")}) {
		my $include_statement = $x->{children};
		# the lines we are looking for look like "<use> <whitespoce> <modulename>"
		my $module = $include_statement->[2]; 

		# in all cases, this must be a word
		next unless ref $module eq "PPI::Token::Word";
		# skip pragmas like strict, warnings, etc
		next if $PERL_PRAGMAS{ $module->{content} };

		# save either the whole module name, or just the subs imported
		if ($include_statement->[4] && ref $include_statement->[4] eq 'PPI::Token::QuoteLike::Words') {
			# save the sub names if we import them
			$manual_includes{ $module->{content} } = [ $include_statement->[4]->literal ];
		} else {
			# save the module name
			$general_includes{ $module->{content} } = 1;
		}
	}

	if ($debug) {
		foreach my $module (keys %general_includes) {
			if (-e filename_from_module($module)) {
				say "$indentstring$module imported";
			} else {
				say "${indentstring}can't find actual file of module $module";
			}
		}

		while (my ($module, $subs) = each %manual_includes) {
			if (-e filename_from_module($module)) {
				say "$indentstring$module imports  " . join(',', @$subs);
			} else {
				say "${indentstring}can't find actual file of module $module";
			}
		}
	};

	return (\%manual_includes, \%general_includes);
}

# given a module name, return the file name
sub filename_from_module {
	my $module = shift;
	my $filename = `whichpm $module`;
	chomp $filename;
	return $filename;
}

# given a PPI document, return a list of things/names used in it
# names mean any subroutine or variable
# returns a hash set, where every name is a key with a value of 1
sub names_used_in_document {
	my $ppi_doc = shift;

	my %names;

	# fina all subroutine calls that aren't part of an include statment
	if ($ppi_doc->find("PPI::Token::Word")) {
		%names = map { $_->{content} => 1 }
						grep { $_->parent->class ne "PPI::Statement::Include" }
						@{$ppi_doc->find("PPI::Token::Word")};
	}

	# find variables, plus subroutine-symbol syntax, and anything else preceded with a sigil
	foreach (@{$ppi_doc->find("PPI::Token::Symbol")}) {
		$_ = $_->content;
		s/^&//;  # treat subroutine names as regular subroutines (we don't care about their calling syntax)
		$names{ $_ } = 1;
	}

	# remove names that are built into perl
	foreach (keys %names) {
		delete $names{$_} if $PERL_KEYWORDS{$_};
		delete $names{$_} if $PERL_BUILTINS{$_};
	}

	return \%names;
}

# given a module, return an arryref of subroutines it has (we include
# constants in this list. ideally it would also have global variables)
sub find_names_declared_in_module {
	my $module = shift;

	my $ppi_doc = PPI::Document->new( filename_from_module($module) );

	# we'll fill this variable with the names of subs we find, and return a ref to it
	my @sub_names;

	# find all sub statements. the third child is the subroutine name, "sub <whitespace> <NAME>"
	if ($ppi_doc->find("PPI::Statement::Sub")) {
		push @sub_names, map { $_->{children}[2]{content} } (@{$ppi_doc->find("PPI::Statement::Sub")});
	}

	# find all constants. they look like "use <whitespace> constants <whitespace> <NAME>"
	if ($ppi_doc->find("PPI::Statement::Include")) {
		push @sub_names, map { $_->{children}[4]{content} }
						grep { $_->{children}[2]{content} eq 'constants' }
						(@{$ppi_doc->find("PPI::Statement::Include")});
	}

	# find global variables. they look like "our <whitespace> <VARIABLE>" or "our <whitespace> ( <VARIABLE> <VARIABLE> ... )"
	if ($ppi_doc->find("PPI::Statement::Variable")) {
		foreach my $v ( @{$ppi_doc->find("PPI::Statement::Variable")}) {
			my $children = $v->{children};
			next unless $children->[0]->{content} eq 'our';
			push @sub_names, map { $_->{content} } @{ $v->find('PPI::Token::Symbol') };
		}
	}

	# if the module looks like an object, automatically include a "new" sub
	# TODO: bug: AthenaUtils is being given a "new" sub
	if ($ppi_doc->find("PPI::Statement::Include")) {
		push @sub_names, 'new' if grep { $_->{content} =~ /\b(Athena::Moose|Moose|Athena::Object|AthenaObject)\b/ }
								  map { @{$_->{children}} }
								  @{$ppi_doc->find("PPI::Statement::Include")};
	}

	return \@sub_names;
}

sub check_general_includes {
	my ($names, $general_includes) = @_;

	foreach my $module (sort keys %$general_includes) {
		my $subs = $general_includes->{$module};
		my @subs_used;

		foreach my $sub (@$subs) {
			print "${indentstring}looking for $sub from $module..." if $debug;
			# TODO: once I sort out EXPORTing, this will change
			if ($names->{$sub} || $names->{"${module}::$sub"}) {
				print colored("found it\n", 'green') if $debug;
				push @subs_used, $sub;
			} else {
				print colored("did not find it\n", 'red') if $debug;
			}
		}

		say @subs_used ? colored("$module in use. Used " . join(',', @subs_used) . '.', 'green')
						: colored("$module not in use", 'red') ;
	}
}


sub check_manual_includes {
	my ($names, $manual_includes) = @_;

	# TODO: handle modules like Athena::Policy which do imports into the caller's space. probably by id'ing
	# "sub import" and looking for "foo->import", and marking those specially (we still want to check for
	# functions used)

	foreach my $module (sort keys %$manual_includes) {
		my $subs = $manual_includes->{$module};

		my @subs_used;
		my @subs_unused;

		foreach my $sub (@$subs) {
			print "${indentstring}looking for $sub from $module..." if $debug;
			if ($names->{$sub}) {
				print colored("found it\n", 'green') if $debug;
				push @subs_used, $sub;
			} else {
				print colored("did not find it\n", 'red') if $debug;
				# we only want to keep track of the subs that the file explicitly included but didn't use.
				# if it's just a package sub, don't bother
				push @subs_unused, $sub unless $sub =~ /^${module}::/;
			}
		}

		if (@subs_used && @subs_unused) {
			print colored("$module in partial use.", 'cyan');
			print colored('Used ' . join(',', @subs_used) . '. ', 'green') if @subs_used;
			print colored("Didn't use " . join(',', @subs_unused) . '.', 'red') if @subs_unused;
			print "\n";
		} elsif (@subs_used) {
			say colored("$module in use. Used " . join(',', @subs_used) . '.', 'green');
		} elsif (@subs_unused) {
			say colored("$module not in use. Didn't use " . join(',', @subs_unused) . '.', 'red');
		} else {
			say colored("$module not in use.", 'red');
		}
	}
}

