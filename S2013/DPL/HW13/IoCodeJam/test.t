#!/usr/bin/perl
use 5.10.0;
use strict;

use Test::Simple tests => 4;

sub test_codejam {
    my ($script, $input, $correct) = @_;
    system("io $script data/$input > /tmp/xx.$$");
    my $good = `diff data/$correct /tmp/xx.$$` == 0;
    unlink("/tmp/xx.$$");
    return $good;
}

ok(test_codejam("reverse_words.io", "one.in", "one.out"), "reverse words: small");
ok(test_codejam("reverse_words.io", "two.in", "two.out"), "reverse words: big");
ok(test_codejam("t9_spelling.io", "three.in", "three.out"), "t9 spelling: small");
ok(test_codejam("t9_spelling.io", "four.in", "four.out"), "t9 spelling: big");

