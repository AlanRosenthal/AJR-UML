#!/usr/bin/perl
use 5.12.0;
use warnings;

use Test::Simple tests => 22;
    
system("(cd NormLC && make 2>&1) > /dev/null");

sub lcalc {
    my ($code) = @_;
    my $result = `echo "$code" | ./Lambda`;
    chomp $result;
    return $result;
}

# To compare two lambda calculus expressions, we must first
# normalize the variable names.

sub norm_lx {
    my ($code) = @_;
    my $result = `echo "$code" | NormLC/NormLC`;
    chomp $result;
    return $result;
}

our $quiet = 0;

sub eq_lx {
    my ($aa, $bb) = @_;
    $aa = norm_lx($aa);
    $bb = norm_lx($bb);

    if ($aa ne $bb) {
        say "Expressions don't match:";
        say " aa = $aa";
        say " bb = $bb";
    }

    return $aa eq $bb;
}

ok(eq_lx(lcalc("x"), "x"), "x is x");
ok(eq_lx(lcalc("(&x.x)y"), "y"), "identity of y is y");
ok(eq_lx(lcalc("(&x.xx)y"), "yy"), "dup");
ok(eq_lx(lcalc("(&x.xx)(&x.xx)z"), "(&x.xx)(&x.xx)z"), "dup of dup");
ok(eq_lx(lcalc("(&x.(&y.xy))y"), "(&t.yt)"), "renaming example 1");
ok(eq_lx(lcalc("(&x.(&y.(x(&x.xy))))y"), "(&t.y(&x.xt))"), "renaming example 2");

ok(eq_lx(lcalc("(&wxy.ywx)abc"), "cab"), "multi-argument functions");
ok(eq_lx(lcalc("I"), "(&x.x)"), "builtin identity");
ok(eq_lx(lcalc("S"), "(&w.(&y.(&x.y(wyx))))"), "builtin successor");
ok(eq_lx(lcalc("0"), "(&s.(&z.z))"), "builtin zero");
ok(eq_lx(lcalc("1"), "(&s.(&z.sz))"), "builtin one");
ok(eq_lx(lcalc("7"), "(&s.(&z.s(s(s(s(s(s(sz))))))))"), "builtin 7");
ok(eq_lx(lcalc("+"), "(&x.(&y.x(&w.(&y.(&x.y(wyx))))y))"), "builtin +");
ok(eq_lx(lcalc("*"), "(&x.(&y.(&z.x(yz))))"), "builtin *");

ok(eq_lx(lcalc("(&w.(&y.(&x.y(wyx))))(&s.(&z.z))"), "(&y.(&x.yx))"),
    "literal successor to zero");
ok(eq_lx(lcalc("S0"), "(&y.(&x.yx))"), "builtin S0");
ok(eq_lx(lcalc("+ 2 3"), "(&s.(&z.s(s(s(s(sz))))))"), "addition 1");
ok(eq_lx(lcalc("+ 2 1"), "(&s.(&z.s(s(sz))))"), "addition 2");
ok(eq_lx(lcalc("* 4 3"), "(&s.(&z.s(s(s(s(s(s(s(s(s(s(s(sz)))))))))))))"), 
    "multiplication 1");
ok(eq_lx(lcalc("* 2 3"), "(&s.(&z.s(s(s(s(s(sz)))))))"),
    "multiplication 2");

ok(eq_lx(lcalc("S (* 2 (+ 1 1))"), "(&y.(&x.y(y(y(y(yx))))))"), "complex expr 1");
ok(eq_lx(lcalc("S(S(S(0)))"), "(&y.(&x.y(y(yx))))"), "complex expr 2");

