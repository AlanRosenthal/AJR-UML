#!/usr/bin/perl
use 5.12.0;
use warnings;

use Test::Simple tests => 8;

sub run {
    my ($expr) = @_;
    my $result = `ghc Monads.hs -e 'print ($expr)'`;
    chomp $result;
    return $result;
}

ok(run('run 1 $ inc 5') eq "Just 6", "One Step");
ok(run('run 0 $ inc 5') eq "Nothing", "No Steps");
ok(run('run 10 $ fact 2') eq "Just 2", "fact 2");
ok(run('run 10 $ signum (-2)') eq "Just (-1)", "signum");

ok(run('run 320 $ fact 17') eq "Nothing", "fact 17");
ok(run('run 330 $ fact 17') eq "Just 355687428096000", "fact 17 (2)");

ok(run('minSteps (1 + 1)') == 1, "minSteps (+)");
ok(run('minSteps (fact 17)') == 324, "minSteps (fact 10)");
