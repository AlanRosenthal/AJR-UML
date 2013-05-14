#!/usr/bin/perl
use 5.12.0;
use warnings;

use Test::Simple tests => 25;
use IO::Handle;

sub run_code {
    my ($code) = @_;
    my $test_class = "Test$$";
    my $test_src   = "$test_class.scala";
    open my $tt, ">", $test_src;
    $tt->print(<<END);
    object $test_class {
        def main(args: Array[String]) {
            $code
        }
    }
END
    close $tt;

    system(qq{scalac "$test_src"});
    my $result = `scala "$test_class"`;
    chomp $result;
    return $result;
}

sub call_meth {
    my ($code) = @_;
    return run_code("println(ScalaBasics.$code)");
}

sub brew_coffee {
    my ($type) = @_;
    my $result = `scala Brew "$type"`;
    chomp $result;
    return $result;
}

sub eq_no_ws {
    my ($aa, $bb) = @_;
    chomp $aa; $aa =~ s/\s+/ /g;
    chomp $bb; $bb =~ s/\s+/ /g;

    if ($aa ne $bb) {
        say "Equality test failed:";
        say " aa = [$aa]";
        say " bb = [$bb]";
        return 0;
    }

    return 1;
}

$ENV{CLASSPATH} = ".";

# Call into Java
ok(brew_coffee("decaf") eq "Brewing decaf coffee.", "Java Interop - decaf");
ok(brew_coffee("dark roast") eq "Brewing dark roast coffee.", "Java Interop - dark roast");

# Map from Fold
#   Should be generic enough to handle various sequence types with any type
#   of value in them.

ok(call_meth('map(((a:Int) => a + 1), List(1,2,3)).mkString(",")') eq "2,3,4",
    "map List[Int]");
ok(call_meth('map(((a:Double) => a * 2.0), Array(1.0,2.0,3.0)).mkString(",")') 
      eq "2.0,4.0,6.0", "map Array[Double]");
ok(call_meth('map(((a:String) => a + a), Vector("a","bb")).mkString(",")')
      eq "aa,bbbb", "map Vector[String]");

# Fib - Iterative, Recursive

ok(call_meth("fibR(1)") == 1, "fib of 1 is 1");
ok(call_meth("fibR(2)") == 1, "fib of 2 is 1");
ok(call_meth("fibR(10)") == 55, "fib of 10 is 55");
ok(call_meth("fibI(30)") == 832040, "fib of 30 is 832040");

ok(call_meth("fibI(1)") == 1, "fib of 1 is 1");
ok(call_meth("fibI(2)") == 1, "fib of 2 is 1");
ok(call_meth("fibI(10)") == 55, "fib of 10 is 55");
ok(call_meth("fibI(30)") == 832040, "fib of 30 is 832040");

# Square Array, Square List

sub square_array {
    my $xs = join(",", @_);
    my $code = <<"EOF";
var xs = Array[Int]($xs);
ScalaBasics.squareArrayInPlace(xs);
println(xs.mkString(","));
EOF
    return run_code($code);
}

ok(square_array(1,2,3) eq "1,4,9", "SquareArray(1,2,3)");
ok(square_array() eq "", "SquareArray()");
ok(square_array(3,6,9,12) eq "9,36,81,144", "SquareArray(3,6,9,12)");

ok(call_meth('squareList(List(1,2,3)).mkString(",")') eq "1,4,9", "SquareList(1,2,3)");
ok(call_meth('squareList(List[Int]()).mkString(",")') eq "", "SquareList()");
ok(call_meth('squareList(List(3,6,9,12)).mkString(",")') eq "9,36,81,144", 
    "SquareList(3,6,9,12)");

# Ducks, Dogs, and Mice

ok(run_code('val dd = new Duck("Steve"); dd.speak();') eq "Steve: Quack!", 
    "Steve the Duck");
ok(run_code('val dd = new Dog("Lassie"); dd.speak();') eq "Lassie: Woof!",
    "Lassie the Dog");
ok(run_code('val dd = new Mouse("Ron"); dd.speak();') eq "Ron: Squeek!",
    "Ron the Mouse");

# Matrix class

my $mcode0 = <<EOF;
var m4x4 = new Matrix(4, 4)
m4x4(1, 2) = 3
println(m4x4)
EOF

my $mat0 = <<EOF;
Matrix(4,4):
0 0 0 0
0 0 3 0
0 0 0 0
0 0 0 0
EOF

ok(eq_no_ws(run_code($mcode0), $mat0), "Matrix toString");

my $mcode1 = <<EOF;
var m4x4 = new Matrix(4, 4)
m4x4(1, 2) = 3
m4x4.transpose()
println(m4x4)
EOF

my $mat1 = <<EOF;
Matrix(4,4):
0 0 0 0
0 0 0 0
0 3 0 0
0 0 0 0
EOF

ok(eq_no_ws(run_code($mcode1), $mat1), "Matrix transpose");

my $mcode2 = <<EOF;
var m4x4 = new Matrix(4, 4)
m4x4(1, 2) = 3
m4x4.transpose()
println("" + m4x4(1,2) + "," + m4x4(2, 1))
EOF

ok(run_code($mcode2) eq "0,3", "Matrix get");



