#!/usr/bin/perl
use 5.12.0;
use warnings;

use Test::Simple tests => 2;

system("./reverse_words < data/one.in > one.$$");
my $bad1 = `diff one.$$ data/one.out | wc -l`;
unlink "one.$$";

ok($bad1 == 0, "reverse words - test 1");

system("./reverse_words < data/two.in > two.$$");
my $bad2 = `diff two.$$ data/two.out | wc -l`;
unlink "two.$$";

ok($bad2 == 0, "reverse words - test 2");
