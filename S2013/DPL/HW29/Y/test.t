#!/usr/bin/perl
use 5.12.0;
use warnings;

use Test::Simple tests => 20;
    
system("(cd NormLC && make 2>&1) > /dev/null");

sub lcalc {
    my ($code) = @_;
    my $result = `echo "$code" | ./Lambda | tail -n 1`;
    chomp $result;
    return $result;
}

# To compare two lambda calculus expressions, we must first
# normalize the variable names.

sub norm_lx {
    my ($code) = @_;
    my $result = `echo "$code" | NormLC/NormLC`;
}

sub eq_lx {
    my ($aa, $bb) = @_;
    $aa = norm_lx($aa);
    $bb = norm_lx($bb);

    if (${^CHILD_ERROR_NATIVE} != 0) {
        say "That's not a reduced lambda calculus expression.";
        return 0;
    }

    if ($aa ne $bb) {
        say "Expressions don't match:";
        say " aa = $aa";
        say " bb = $bb";
        return 0;
    }

    return 1;
}

# Stuff from before
ok(eq_lx(lcalc("(&x.xx)y"), "yy"), "simple application");
ok(eq_lx(lcalc("(&wxy.ywx)abc"), "cab"), "multi-argument functions");
ok(eq_lx(lcalc("7"), "(&s.(&z.s(s(s(s(s(s(sz))))))))"), "builtin number");
ok(eq_lx(lcalc("+ 3 5"), "(&s.(&z.s(s(s(s(s(s(s(sz)))))))))"), "addition");
ok(eq_lx(lcalc("(&x.(&y.xy))y"), "(&t.yt)"), "renaming example 1");
ok(eq_lx(lcalc("(&x.(&y.(x(&x.xy))))y"), "(&t.y(&x.xt))"), "renaming example 2");

# New Builtins
ok(eq_lx(lcalc("T"), "(&xy.x)"), "true");
ok(eq_lx(lcalc("F"), "(&xy.y)"), "false");
ok(eq_lx(lcalc("N"), "(&x.x(&uv.v)(&ab.a))"), "not");
ok(eq_lx(lcalc("Z"), lcalc("(&x.xFNF)")), "zero?");

ok(eq_lx(lcalc("P1"), lcalc("0")), "pred 1");
ok(eq_lx(lcalc("P5"), lcalc("4")), "pred 2");

# Factorial
ok(eq_lx(lcalc("A1"), lcalc("1")), "fact(1) = 1");
ok(eq_lx(lcalc("A3"), lcalc("6")), "fact(3) = 6");
ok(eq_lx(lcalc("A4"), lcalc("24")), "fact(4) = 24");
ok(eq_lx(lcalc("A5"), lcalc("120")), "fact(5) = 120");

# Subtraction
ok(eq_lx(lcalc("- 10 3"), lcalc("7")), "10 - 3 = 7");
ok(eq_lx(lcalc("- 40 27"), lcalc("13")), "40 - 27 = 13");

# Division
ok(eq_lx(lcalc("/ 4 2"), lcalc("2")), "4 / 2 = 2");
ok(eq_lx(lcalc("/ 26 5"), lcalc("5")), "26 / 5 = 5");
