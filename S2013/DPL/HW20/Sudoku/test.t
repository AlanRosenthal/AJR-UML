#!/usr/bin/perl
use 5.12.0;
use warnings;

use Test::Simple tests => 2;

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

my $puz1 = <<"END";
sudoku(Out,
   [8, _, _, 9, _, _, 1, 5, _,
    7, 1, _, _, 5, _, _, _, 4,
    4, _, 6, _, _, _, 7, 9, _,
    _, 7, 4, _, 1, _, 3, _, 2,
    _, _, _, 7, _, 2, _, _, _,
    9, _, 2, _, 8, _, 6, 1, _,
    _, 4, 8, _, _, _, 5, _, 1,
    2, _, _, _, 6, _, _, 7, 8,
    _, 6, 7, _, _, 8, _, _, 9])
END

my $sol1 = "[8,2,3,9,7,4,1,5,6,7,1,9,3,5,6,8,2,4,4,5,6,8,2,"
           ."1,7,9,3,5,7,4,6,1,9,3,8,2,6,8,1,7,3,2,9,4,5,9,"
           ."3,2,4,8,5,6,1,7,3,4,8,2,9,7,5,6,1,2,9,5,1,6,3,"
           ."4,7,8,1,6,7,5,4,8,2,3,9]";

my $out1 = pl_test("sudoku.pl", $puz1);
chomp($out1);

ok($out1 eq $sol1, "suduku - Puzzle 1");


my $puz2 = <<"END";
sudoku(Out,
    [1, _, _, _, _, 6, 2, 8, 3,
     _, _, _, _, _, 3, 1, _, 7,
     _, _, 7, 8, _, _, 6, 9, _,
     2, _, 1, 6, 3, _, _, _, _,
     4, _, _, _, _, _, _, _, 1,
     _, _, _, _, 5, 1, 8, _, 6,
     _, 7, 2, _, _, 5, 4, _, _,
     3, _, 6, 9, _, _, _, _, _,
     8, 1, 4, 3, _, _, _, _, 9])
END

my $sol2 = "[1,4,9,5,7,6,2,8,3,6,2,8,4,9,3,1,5,7,5,3,7,8,1,"
           ."2,6,9,4,2,8,1,6,3,4,9,7,5,4,6,5,7,8,9,3,2,1,7,"
           ."9,3,2,5,1,8,4,6,9,7,2,1,6,5,4,3,8,3,5,6,9,4,8,"
           ."7,1,2,8,1,4,3,2,7,5,6,9]";

my $out2 = pl_test("sudoku.pl", $puz2);
chomp($out2);

ok($out2 eq $sol2, "suduku - Puzzle 2");
