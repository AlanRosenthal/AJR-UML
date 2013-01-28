#!/usr/bin/perl
use 5.10.0;
use strict;

use Test::Simple tests => 2;

my $bin = `basename \`pwd\``;
chomp $bin;

system("./$bin < one.in > /tmp/xx.$$");
ok(`diff one.out /tmp/xx.$$` == 0, "Small test case");

unlink("/tmp/xx.$$");

system("./$bin < two.in > /tmp/xx.$$");
ok(`diff two.out /tmp/xx.$$` == 0, "Big test case");

unlink("/tmp/xx.$$");
