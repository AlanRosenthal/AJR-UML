#!/usr/bin/perl
use 5.10.0;
use strict;

use Test::Simple tests => 8;

my $units = <<'END_UNITS';
{
  meters:    1.0,
  feet:      0.3048,
  parsecs:   3.0856e16,
  smoots:    1.7018,
  furlongs:  201.16,
  angstroms: 1.0e-10
}
END_UNITS

my $eps = 0.001;

sub units_test {
    my ($code, $num, $unit) = @_;
    my $result = `ruby -r./units.rb -e'\$units = $units; puts($code.to_s)'`;

    chomp $result;
    my ($vv, $uu) = split /\s/, $result;

    return 0 if(abs($num - $vv) > $eps);
    return 0 if($unit ne $uu);
    return 1;
}

sub eval_ruby_match {
    my ($code, $pat) = @_;
    my $result = `(ruby -r./units.rb -rjson -e'puts $code' 2>&1)`;
    chomp $result;
    if ($result =~ $pat) {
        return 1;
    }
    else {
        say "Expected: '$pat' but got '$result'";
        return 0;
    }
}

# Ruby still works

ok(eval_ruby_match("5.to_s", qr/^5$/), "Integer to_s");
ok(eval_ruby_match("87.5.to_s", qr/^87.5$/), "Float to_s");
ok(eval_ruby_match("29.pies", qr/undefined method/), "Units valid (1)");
ok(eval_ruby_match("18.feet.in_pies", qr/undefined method/), "Units valid (2)");

# Basic Conversions

ok(units_test("5.feet", 5, "feet"), "5.feet");
ok(units_test("5.meters.in_feet.in_meters", 5, "meters"), "round trip");
ok(units_test("430.3.smoots.in_furlongs", 3.6403, "furlongs"), "smoots to furlongs");
ok(units_test("430.3.smoots.in_feet.in_furlongs", 3.6403, "furlongs"), "through feet");
