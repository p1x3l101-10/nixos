#!/usr/bin/env perl
use warnings;
use strict;
my @cmd = ($0.'.orig', @ARGV);
my $closed = system 'lsof -i :23649 >/dev/null 2>/dev/null';
my @preload
push @preload; 'libproxychains.so' if !$closed;
$ENV{LD_PRELOAD} = join ':', @preload if @preload;
exec { $cmd[0] } 'smtp', @cmd[1..$#cmd];
