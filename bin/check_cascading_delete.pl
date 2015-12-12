#!/usr/bin/env perl

use strict;
use warnings;

undef $/;

unless (@ARGV) {
    print <<END_OF_USAGE;
usage: $0 <files>
files is one or more DBIx::Class files, probably in lib/.../Schema/Result/
lines marked with a * mean that it's using implicit defaults
END_OF_USAGE
    exit;
}

foreach my $file (@ARGV) {
    open my $FH, '<', $file or die;
    my $alllines = <$FH>;
    while( $alllines =~
            /^__PACKAGE__->(?:has_many|might_have)\(
              \s* (\w+) \s* => \s* '[^']+:([^:']+)', \s*
              (.+?)
             ^\); \s* $
            /msxg
    ) {
        my ($attribute, $package, $therest) = ($1, $2, $3);
        if ($therest =~ /cascade_delete \s* => \s* (\d) /x) {
            print "Deleting $file "
                  . ( $1 ? "will" : "won't" )
                  . " delete $attribute ($package)\n";
        } else {
            print "Deleting $file will delete $attribute ($package)*\n";
        }
    }

}

__END__

has_many, might_have
    cascade deletes are on by default

belongs_to
    cascade deletes are off by default

we don't look for belongs_to

