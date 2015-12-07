#!/usr/bin/perl

use strict;
use warnings;

foreach my $module ( @ARGV ) {
  eval "require $module";
  my $filename = join('/', split('::', $module)) . '.pm';
  printf( "%s (%s) %s\n", $module, $INC{$filename}, $module->VERSION ) unless ( $@ );
}

