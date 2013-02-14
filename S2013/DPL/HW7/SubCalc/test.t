#!/usr/bin/perl
use 5.10.0;
use strict;

use Test::Simple tests => 5;

use IO::Handle;

our $OUTPUT = "/tmp/out.$$.txt";

sub test_exp {
    my ($exp) = @_;
    chomp $exp;

    open my $pipe, "|./SubCalc > $OUTPUT";
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

    say "Got result: $result";

    return $result;
}

ok(test_exp("2 + 5 * 2") == 12, "Simple Expression");

my $sub_test1 = <<DONE
sub inc(n) n + 1 end
inc(5)
DONE
;
ok(test_exp($sub_test1) == 6, "inc sub");

my $sub_test2 = <<DONE
sub fact(n) if n < 1 then 1 else n * fact(n - 1) end end
fact(5)
DONE
;
ok(test_exp($sub_test2) == 120, "fact sub");

my $sub_test3 = <<DONE
sub second(a, b, c) b end
sub third(a, b, c) c end
second(1, 2, 3) - third(1, 2, 3)
DONE
;
ok(test_exp($sub_test3) == -1, "two subs");

my $sub_test4 = <<DONE
sub inc(n) n + 1 end
inc(inc(inc(inc(inc(5)))))
DONE
;
ok(test_exp($sub_test4) == 10, "multiple inc");
