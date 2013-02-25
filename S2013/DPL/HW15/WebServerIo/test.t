#!/usr/bin/perl
use 5.10.0;
use strict;

use Test::Simple tests => 13;

use Time::HiRes qw(time sleep);
use List::Util qw(sum);

sub run_test {
    my ($a, $b) = @_;

    my $server_cmd = ($a == 0) ? 'ruby server0.rb' : 'io server1.io';
    my $cmd = "bash -c '($server_cmd > /dev/null) & echo \$!'";

    my $pid = `$cmd`;

    sleep(0.1);

    my $t0 = time();

    my $client_cmd = "io client$b.io";

    my $text = `$client_cmd`;
    my $t1 = time();
    my $elapsed = $t1 - $t0;

    kill(15, $pid);

    return ($elapsed, $text);
}

sub eq_no_ws {
    my ($a, $b) = @_;
    $a =~ s/\s//g;
    $b =~ s/\s//g;

    if ($a ne $b) {
        say "# Strings not equal:";
        say "# a = '$a'";
        say "# b = '$b'"
    }

    return $a eq $b;
}

sub ne_no_ws {
    my ($a, $b) = @_;
    $a =~ s/\s//g;
    $b =~ s/\s//g;

    if ($a eq $b) {
        say "# Strings should not be equal:";
        say "# a = '$a'";
        say "# b = '$b'"
    }

    return $a ne $b;
}

sub client_all_finished {
    my ($text) = @_;
    $text =~ s/:.*$//mg;
    my $sum = sum(split(/\s+/, $text));
    return $sum == 10;   
}

sub client_in_order {
    my ($text) = @_;
    $text =~ s/:.*$//mg;
    return eq_no_ws($text, "01234");
}

sub arrays_in_order {
    my ($text) = @_;
    $text =~ s/^.*:\s*\[//mg;
    $text =~ s/[\]\,]//mg;
    return eq_no_ws($text, "001012012301234");
}

sub arrays_not_in_order {
    my ($text) = @_;
    $text =~ s/^.*:\s*\[//mg;
    $text =~ s/[\]\,]//mg;
    return ne_no_ws($text, "001012012301234");
}

sub arrays_no_dups {
    my ($text) = @_;
    $text =~ s/^.*:\s*\[//mg;
    $text =~ s/\]//mg;
    for my $ll (split /\n/, $text) {
        my %seen = ();
        for my $nn (split /,\s*/, $ll) {
            return 0 if (defined $seen{$nn});
            $seen{$nn} = 1;
        }
    }
    return 1;
}

my ($tt, $text);

say "# Note: Some tests use random numbers and have a small chance of";
say "#   wrongly failing. If you suspect this, try testing again locally.";

($tt, $text) = run_test(0, 0);
ok(client_in_order($text), "0 0 - client requests finished in order");
ok(arrays_in_order($text), "0 0 - server generated ordered arrays");
ok($tt > 3.0, "0 0 - took at least 3 seconds");

($tt, $text) = run_test(0, 1);
ok(arrays_not_in_order($text), "0 1 - server did not generate ordered arrays");
ok(client_all_finished($text), "0 1 - client requests all finished");
ok(arrays_no_dups($text), "0 1 - server generated no duplicates in arrays");
ok($tt < 3.0, "0 1 - took less than 3 seconds");

($tt, $text) = run_test(1, 0);
ok(client_in_order($text), "1 0 - client requests finished in order");
ok(arrays_in_order($text), "1 0 - server generated ordered arrays");
ok($tt > 3.0, "1 0 - took at least 3 seconds");

($tt, $text) = run_test(1, 1);
ok(arrays_not_in_order($text), "1 1 - server did not generate ordered arrays");
ok(client_all_finished($text), "1 1 - client requests all finished");
ok($tt < 3.0, "1 1 - took less than 3 seconds");
