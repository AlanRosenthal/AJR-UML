#!/usr/bin/perl
use 5.12.0;
use warnings;

use Test::Simple tests => 1;

my $result = `./uml`;

ok($result == 24, "uml scheduler -- correct result");
