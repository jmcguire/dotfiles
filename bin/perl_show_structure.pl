#!/usr/local/bin/perl

use strict;
use warnings;
use feature 'say';

my %all;
my $last_p = undef;

while (<>) {
    $last_p = undef if eof;

    my ($p) = /^package (.+);/;
    $last_p = $p if $p;

    my ($s) = /^sub (\w+)\b/;
    next unless $s;

    $all{$last_p}{$s}++;
}

for my $p (keys %all) {
    say "\n$p";
    say "\t$_" for keys %{$all{$p}};
}

