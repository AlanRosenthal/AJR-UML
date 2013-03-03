#!/usr/bin/perl
use 5.12.0;
use warnings;

use Test::Simple tests => 4;

use IO::Handle;

# pl_test
#
# Takes a prolog file and a predicate to run in the
# context of that file. The predicate should bind the
# "Out" variable, which will then be printed.

sub pl_test {
    my ($user_file, $pred) = @_;

    my $test_bin = "test-$$";
    my $test_src = "$test_bin.pl";

    open my $tt, ">", $test_src;

    open my $in, "<", $user_file;
    while(<$in>) {
        $tt->print($_);
    }
    close $in;

    $tt->print(<<"END");
start :-
    $pred,
    write(Out), nl.

:- initialization(start).
END

    close $tt;

    system("(make $test_bin 2>&1) > /dev/null");
    my $output = `./$test_bin`;

    unlink $test_bin;
    unlink $test_src;
    return $output;
}

ok(pl_test("basics.pl", "fib(Out, 7)") == 13, "fib");

my $squared_list = pl_test("basics.pl", "square_list(Out, [2,4,6,8])");
chomp $squared_list;

ok($squared_list eq "[4,16,36,64]", "square_list");

my $sort_pred = <<"END";
Xs = [33, 55, 29, 18, 11, 5, 371, 8, 2],
my_sort(Out, Xs)
END

my $sort_text = pl_test("my_sort.pl", $sort_pred); 
chomp $sort_text;

ok($sort_text eq "[2,5,8,11,18,29,33,55,371]", "my_sort - sorts a list");

my $kaz_pred = <<"END";
setof([WestKaz, Atyrau, Aktobe, Mangystau, Kostanay, NorthKaz, Akmola, Pavlodar, 
    Karagandy, Kyzylorda, SouthKaz, Zhambyl, Almaty, EastKaz], 
  coloring(WestKaz, Atyrau, Aktobe, Mangystau, Kostanay, NorthKaz, Akmola, 
    Pavlodar, Karagandy, Kyzylorda, SouthKaz, Zhambyl, Almaty, EastKaz),
  L),
  length(L, Out)
END

ok(pl_test("kazakhstan.pl", $kaz_pred) == 36576, 
    "Kazakhstan - Right number of solutions");

