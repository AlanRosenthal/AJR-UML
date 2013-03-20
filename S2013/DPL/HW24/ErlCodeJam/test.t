#!/usr/bin/perl
use 5.12.0;
use warnings;

use Test::Simple tests => 4;

sub test_codejam {
    my ($script, $input, $correct) = @_;

    system("./$script data/$input > out-$$.tmp");
    my $diff = `diff out-$$.tmp data/$correct | wc -l`;
    unlink "out-$$.tmp";

    if ($diff != 0) {
       say "Your program ($script) did not produce the expected";
       say "result for test case (data/$input).";
       say "";
       say "Try this to see the error:";
       say "  ./$script data/$input > output.txt";
       say "  diff output.txt data/$correct";
       return 0;
    }

    return 1;
}

ok(test_codejam("reverse_words", "one.in", "one.out"), "reverse words - test 1");
ok(test_codejam("reverse_words", "two.in", "two.out"), "reverse words - test 2");

ok(test_codejam("t9_spelling", "three.in", "three.out"), "t9 - test 1");
ok(test_codejam("t9_spelling", "four.in", "four.out"), "t9 - test 2");
