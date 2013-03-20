#!/usr/bin/perl
use 5.12.0;
use warnings;

use Test::Simple tests => 9;

sub eval_erl {
    my ($code) = @_;
    my $yy = `erl -noshell -eval 'Out = $code, io:format("~w~n", [Out])' -s erlang halt`;
    chomp $yy;
    return $yy;
}

# Fib

ok(eval_erl("basics:fib(1)") == 1, "fib - fib of 1");
ok(eval_erl("basics:fib(10)") == 55, "fib - fib of 10");
ok(eval_erl("basics:fib(30)") == 832040, "fib - fib of 30");

# Square List

ok(eval_erl("basics:square_list1([])") eq "[]", 
    "square list 1 - empty list");
ok(eval_erl("basics:square_list1([3, 9, 7])") eq "[9,81,49]", 
    "square list 1 - non-empty");

ok(eval_erl("basics:square_list2([3, 9, 7])") eq "[9,81,49]", 
    "square list 2 - non-empty");


# map from fold

ok(eval_erl("basics:map1(fun(X) -> X + 3 end, [3,2])") eq "[6,5]",
    "map from fold");

# primes

ok(eval_erl("basics:prime(4)") == 7, "prime - the 4th prime is 7");
ok(eval_erl("basics:prime(77)") == 389, "prime - the 77th prime is 389");


