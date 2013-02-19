#!/usr/bin/perl
use 5.10.0;
use strict;

use Test::Simple tests => 23;

use IO::Handle;

sub eval_io {
    my ($eval_code) = @_;
    chomp $eval_code;
    my $tmp_code = qq{doFile("io_basics.io");\n$eval_code println\n};

    my $tmp_file = "test-tmp$$.io";
    open my $hh, ">", $tmp_file;
    $hh->print($tmp_code);
    close $hh;

    my $result = `io "$tmp_file"`;
    chomp $result;
    unlink $tmp_file;

#    say qq{eval_io("$eval_code") => $result};

    return $result;
}

sub eqw {
    my ($aa, $bb) = @_;
    chomp $aa; $aa =~ s/\s+/ /g;
    chomp $bb; $bb =~ s/\s+/ /g;
    return $aa eq $bb;
}

# Fib

ok(eval_io("fibR(1)") == 1, "fib of 1 is 1");
ok(eval_io("fibR(2)") == 1, "fib of 2 is 1");
ok(eval_io("fibR(3)") == 2, "fib of 3 is 2");
ok(eval_io("fibR(10)") == 55, "fib of 10 is 55");

ok(eval_io("fibI(1)") == 1, "fib of 1 is 1");
ok(eval_io("fibI(2)") == 1, "fib of 2 is 1");
ok(eval_io("fibI(3)") == 2, "fib of 3 is 2");
ok(eval_io("fibI(10)") == 55, "fib of 10 is 55");
ok(eval_io("fibI(30)") == 832040, "fib of 30 is 832040");

# Square List

ok(eqw(eval_io("squareList1(list(1,2,3))"), "list(1, 4, 9)"), 
    "squareList1([1,2,3])");
ok(eqw(eval_io("squareList1(list())"), "list()"), "squareList1([])");
ok(eqw(eval_io("squareList1(list(22,33,55,93472))"),
        "list(484, 1089, 3025, 8.737015e+09)"),
    "squareList1 - list of bigger numbers");

ok(eqw(eval_io("squareList2(list(1,2,3))"), "list(1, 4, 9)"), 
    "squareList2([1,2,3])");
ok(eqw(eval_io("squareList2(list())"), "list()"), "squareList2([])");
ok(eqw(eval_io("squareList2(list(22,33,55,93472))"),
        "list(484, 1089, 3025, 8.737015e+09)"),
    "squareList2 - list of bigger numbers");

# Foldl with a block

ok(eqw(eval_io("list(1, 2) foldl(block(acc, n, acc - n), 10)"), "7"),
    "foldl with block");

# Map from fold

ok(eqw(eval_io("list(1, 2, 3) map1(block(n, n + 4))"), "list(5, 6, 7)"),
    "map from fold");

# Ducks and Dogs

ok(eqw(eval_io("Duck clone speak"), "Quack!"), "Ducks quack");
ok(eqw(eval_io("Dog clone speak"), "Woof!"), "Dogs bark");

# 2D Matrix

my $mkmat = <<'DONE';
  aa := Matrix dim(4, 4)
  aa set(0, 0, 4)
  aa set(1, 2, 1)
  aa set(2, 3, 7)
  aa set(3, 2, 5)
DONE

ok(eqw(eval_io("$mkmat; aa get(0, 1)"), "0"), "matrix - default value 0");
ok(eqw(eval_io("$mkmat; aa get(1, 2)"), "1"), "matrix - put and get");

my $mat0 = <<'DONE';
Matrix(4, 4):
 4 0 0 0
 0 0 1 0
 0 0 0 7
 0 0 5 0
DONE

ok(eqw(eval_io("$mkmat; aa"), $mat0), "matrix - asString");

my $mat1 = <<'DONE';
Matrix(4, 4):
 4 0 0 0
 0 0 0 0
 0 1 0 5
 0 0 7 0
DONE
ok(eqw(eval_io("$mkmat; aa transpose"), $mat1), "matrix - transpose");
say "a";
say $mat1;
say "b";
say eval_io("$mkmat; aa transpose");