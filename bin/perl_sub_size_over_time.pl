#!/usr/local/bin/perl

=pod

run this like $0 Interface/InterfaceUtils/VendorOptions.pm _GetVendorOptions

it will check out every version of the file from 2001 to 2017, and find the linecount of that subroutine.

it will print comma-separated data

=cut

use feature 'say';

# for a given file and subroutine
my ($file, $subroutine) = @ARGV;

for my $year (2001 .. 2017) {
    for my $month (1 .. 12) {
        my $date = "$year/$month/01";
        `p4 sync //jmcguire/prod/perllib/Athena/$file...\@$date 2>&1 >/dev/null`;
		my $filepath = "/home/jmcguire/p4/prod/perllib/Athena/$file";
		next unless (-e $filepath);

        my $linecount = `~/bin/get-perl-function $subroutine $filepath | wc -l`;
		chomp $linecount;

        say "$date,$linecount";
    }
}

# reset the file to normal
`p4 sync //jmcguire/prod/perllib/Athena/$file 2>&1 >/dev/null`;

