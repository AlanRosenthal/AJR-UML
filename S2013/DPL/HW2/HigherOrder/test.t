#!/usr/bin/perl
use 5.10.0;

use Test::Simple tests => 9;

use IO::Handle;

our $OUTPUT = "/tmp/out.$$.txt";

my $binary = "error";

sub test_exp {
    my ($exp) = @_;

    open my $pipe, "|./$binary > $OUTPUT";
    $pipe->say($exp);
    close $pipe;

    my $result = `cat $OUTPUT`;
    unlink($OUTPUT);

    $result =~ s/\n//g;
    $result =~ s/.*\)//;
    
    return $result;
}

$binary = "Primes";

ok(test_exp("0") == 2, "the first prime is 2");
ok(test_exp("5") == 13, "primes !! 5 = 13");
ok(test_exp("20") == 73, "primes !! 20 = 73");
ok(test_exp("999") == 7919, "1000th prime");
ok(test_exp("9001") == 93199, "larger prime");

$binary = "MapFromFold";

ok(test_exp("") eq "75 110", "Map from fold");

$binary = "MyFold";

ok(test_exp("1 2 3") == 6, "$binary: list of three nums");
ok(test_exp("") == 0, "$binary: empty list");
ok(test_exp("54 3 2 1") == 60, "$binary: slightly longer list");
