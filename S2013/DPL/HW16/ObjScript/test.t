#!/usr/bin/perl
use 5.12.0;
use warnings;

use Test::Simple tests => 7;

sub os_test {
    my ($preload, $expr, $input) = @_;
    $input //= "";
    my $output = `echo '$expr' | ./ObjScript $preload $input`;

    # Take only last line of output.
    chomp $output;
    $output =~ m/\n([^\n]+$)/;
    return $1;
}

# Check string equality ignoring whitespace
sub eq_no_ws {
    my ($aa, $bb) = @_;
    $aa =~ s/\s//g;
    $bb =~ s/\s//g;

    if ($aa ne $bb) {
        say "String equality check failed comparing:";
        say "'$aa' with";
        say "'$bb'";
    }

    return $aa eq $bb;
}

# Fib

ok(os_test("t/fib.ob", "fib(1)") == 1, "fib of 1 is 1");
ok(os_test("t/fib.ob", "fib(2)") == 1, "fib of 2 is 1");
ok(os_test("t/fib.ob", "fib(3)") == 2, "fib of 3 is 2");
ok(os_test("t/fib.ob", "fib(10)") == 55, "fib of 10 is 55");

# Square List
ok(eq_no_ws(os_test("t/squareList.ob", "xs := []; xs.squareList()"),
        "[]"), "squareList on []");
ok(eq_no_ws(os_test("t/squareList.ob", "xs := [1,2,3]; xs.squareList()"),
        "[1,4,9]"), "squareList on [1,2,3]");

# Ducks and Dogs

ok(eq_no_ws(os_test("t/ducksAndDogs.os", "[fido.speak(), daffy.speak()]"),
        qq{["Woof!","Quack!"]}), "Duck typing");
