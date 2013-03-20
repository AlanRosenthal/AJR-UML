#!/usr/bin/perl
use 5.12.0;
use warnings;

use Test::Simple tests => 7;

sub eval_erl {
    my ($code) = @_;
    my $yy = `erl -noshell -eval 'primes:start(), Out = $code, io:format("~w~n", [Out])' -s erlang halt`;
    chomp $yy;
    return $yy;
}

ok(eval_erl("primes:is_prime(2)") eq "true", "2 is prime");
ok(eval_erl("primes:is_prime(13)") eq "true", "13 is prime");
ok(eval_erl("primes:is_prime(7921)") eq "false", "7921 is not prime");
ok(eval_erl("primes:is_prime(65537)") eq "true", "65537 is prime");
ok(eval_erl("primes:is_prime(8454273)") eq "false", 
    "65537 * 129 is not prime");

system("./gen_list > primes.txt");

my $count = 0 + `cat primes.txt | wc -l`;
ok($count == 78498, "Right number of primes under a million");

my $occurs = 0 + `grep 359897 primes.txt | wc -l`;
ok($occurs == 1, "Has arbitrary large prime.");
