#!/usr/bin/perl
use 5.10.0;

use Test::Simple tests => 6;

use IO::Handle;

our $OUTPUT = "/tmp/out.$$.txt";

sub test_exp {
    my ($exp) = @_;

    open my $pipe, "|./FullCalc > $OUTPUT";
    $pipe->say($exp);
    close $pipe;

    my $result = `cat $OUTPUT`;
    unlink($OUTPUT);

    #$result =~ s/^.*\n(.+)$/$1/mg;
    #$result =~ s/.*\)//;

    my @lines = split "\n", $result;
    $result = $lines[-1];

    $result =~ s/\(.*\)//g;
    $result =~ s/\s//g;

    return $result;
}

ok(test_exp("5") == 5, "Constants");
ok(test_exp("5 * 2") == 10, "Single Op");
ok(test_exp("a = 5") == 5, "Simple Assignment");
ok(test_exp("if 3 < 5 do a = 3 end") == 3, "Complex Expr");
ok(test_exp("a = 5\na + 3") == 8, "Use of variable");
ok(test_exp("a = 0\nwhile a < 10 do a = a + 1 end\na") == 10, "While loop");
