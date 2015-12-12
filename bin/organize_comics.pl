#!/usr//bin/perl

## run: organize_comics.pl <list of comics to organize>
## this will put all comics with a similar name into a single folder.
## it will ignore single comics
## it will use existing folders if they exist

use strict;
use warnings;
use List::Util qw{ first };
use List::MoreUtils qw{ uniq true };
use File::Copy qw{ move };

my @phrases = uniq map{ /^(.+) - /; $1 } grep { /^(.+) - / } @ARGV;

foreach my $phrase (@phrases) {
  my @files = grep { /^$phrase/ } @ARGV;
  next unless @files > 1;
  if (-d "$phrase") {
    print "organizing into $phrase\n";
  } else {
    print "creating and organizing into $phrase\n";
    mkdir "$phrase"
  }
  -f $_ and move($_, "$phrase/$_") foreach @files;
}

