#!/usr/bin/perl
use 5.10.0;
use strict;

use Test::Simple tests => 4;

sub test_codejam {
    my ($script, $input, $correct) = @_;
    system("ruby $script data/$input > /tmp/xx.$$");
    my $good = `diff data/$correct /tmp/xx.$$` == 0;
    unlink("/tmp/xx.$$");
    return $good;
}

ok(test_codejam("reverse_words.rb", "one.in", "one.out"), "reverse words: small");
ok(test_codejam("reverse_words.rb", "two.in", "two.out"), "reverse words: big");
ok(test_codejam("t9_spelling.rb", "three.in", "three.out"), "t9 spelling: small");
ok(test_codejam("t9_spelling.rb", "four.in", "four.out"), "t9 spelling: big");

