#!/usr/bin/perl
use 5.10.0;

use Test::Simple tests => 5;

use IO::Handle;

our $OUTPUT = "/tmp/out.$$.txt";

sub test_exp {
    my ($exp) = @_;

    open my $pipe, "|./SimpleCalc > $OUTPUT";
    $pipe->say($exp);
    close $pipe;

    my $result = `cat $OUTPUT`;
    unlink($OUTPUT);

    $result =~ s/\n//g;
    $result =~ s/\s//g;
    $result =~ s/.*\)//;
    return $result;
}

ok(test_exp("5") == 5, "Constants");
ok(test_exp("5 * 2") == 10, "Single Op");
ok(test_exp("5 ^ 2") == 25, "Single Exponentiation");
ok(test_exp("3 * 2 ^ 2") == 12, "Precedence with Multiplication");
ok(test_exp("(25 * -5 ^ 2 - 100) / 5") == 105, "Complex Expr");
