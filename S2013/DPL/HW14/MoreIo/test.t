#!/usr/bin/perl
use 5.10.0;
use strict;

use Test::Simple tests => 7;

use IO::Handle;

sub eval_io {
    my ($eval_code) = @_;
    chomp $eval_code;

    my $tmp_file2 = "test-tmp2-$$.io";
    open my $hh2, ">", $tmp_file2;
    $hh2->print(qq{$eval_code println\n});
    close $hh2;
    
    my $tmp_file1 = "test-tmp1-$$.io";
    open my $hh1, ">", $tmp_file1;
    $hh1->print(qq{doFile("more_io.io")\n});
    $hh1->print(qq{doFile("$tmp_file2")\n});
    close $hh1;

    my $result = `io "$tmp_file1"`;
    chomp $result;

    unlink $tmp_file1;
    unlink $tmp_file2;

    #say qq{eval_io("$eval_code") => $result};

    return $result;
}

sub eqw {
    my ($aa, $bb) = @_;
    chomp $aa; $aa =~ s/\s+/ /g;
    chomp $bb; $bb =~ s/\s+/ /g;

    if ($aa ne $bb) {
        say "[$aa] ne [$bb]";
    }

    return $aa eq $bb;
}

my $examiner = <<'EOF';
Detective := Examiner clone
rob := Detective clone
rob + ignuana
rob iguana(1, a, list(1,2,3) map(*2))
""
EOF

my $expect = <<'EOF';
I am Detective_XX.
My prototype is Detective_XX, so I'm a Detective.
I just got +, with 1 argument(s).
The message came from Object_XX, of type Object
  0: ignuana
I am Detective_XX.
My prototype is Detective_XX, so I'm a Detective.
I just got iguana, with 3 argument(s).
The message came from Object_XX, of type Object
  0: 1
  1: a
  2: list(1, 2, 3) map(*(2))
EOF

my $result = eval_io($examiner);
$result =~ s/0x\w+/XX/g;
say "# POINTS: 2";
ok(eqw($result, $expect), "Examiner report");

my $switch = <<'EOF';
switch(3,
  "zero"; 0,
  "one" println,
  green banana,
  "three"; 3; "popsicle")
EOF

say "# POINTS: 2";
ok(eqw(eval_io($switch), "popsicle"), "switch");

my $map = <<'EOF';
that := 5
myMap := map( "pie" :: list(1,2,3), "iguana" :: 7,
     "bruce wayne" :: "batman", "this" :: that)
EOF

ok(eqw(eval_io("$map\nmyMap"), "map(bruce wayne :: batman, iguana :: 7, ".
       "pie :: list(1, 2, 3), this :: 5)"),
   "map() - literal, asString");

ok(eval_io(qq{$map\nmyMap["iguana"]}) == 7, "map() - [] lookup");

ok(eval_io("comp(x + 1, x <- list(1, 2))") eq "list(2, 3)",
    "comp - list(2, 3)");
ok(eval_io("comp(x + y * z, x <- list(1,2,3), y <- list(1,2,3), ".
        "z <- list(1, 2), x != y, z != 1)") eq  "list(5, 7, 4, 8, 5, 7)",
    "comp - three vars");
ok(eval_io("Range; comp(x + y, x <- 1 to(10) map(x, x), ".
        "y <- 1 to(100) map(x, x)) size") == 1000, 
    "comp - large instance");

