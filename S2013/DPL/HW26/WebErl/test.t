#!/usr/bin/perl
use 5.12.0;
use warnings;

use Test::More tests => 9;
use Time::HiRes qw(sleep);

sub run_pair {
    my ($server, $client) = @_;

    system("(./$server 2>&1) > /dev/null&");
    #system("./$server &"); # Uncomment to show server output.
    sleep(0.25);
    my $text = `./$client`;

    return $text;
}

sub blank_req_no {
    my ($aa) = @_;
    $aa =~ s/^\d+/X/mg;
    return $aa;
}

sub eq_no_ws {
    my ($aa, $bb) = @_;
    $aa =~ s/\s//g;
    $bb =~ s/\s//g;

    if ($aa ne $bb) {
        say "Equality test failed:";
        say "{$aa} ne {$bb}";
        return 0;
    }

    return 1;
}

my $in_order = <<"END";
0: [0]
1: [0, 1]
2: [0, 1, 2]
3: [0, 1, 2, 3]
4: [0, 1, 2, 3, 4]
END

my $respawn_in_order = <<"END";
0: [0]
1: [0,1]
2: [0,1,2]
3: [0]
4: [0,1]
END

my $r00 = run_pair("server0", "client0");
ok(eq_no_ws($r00, $in_order), "server0, client0");

my $r01 = run_pair("server0", "client1");
ok(eq_no_ws(blank_req_no($r01), blank_req_no($in_order)), 
    "server0, client1");
ok($r01 ne $respawn_in_order, "server0, client1; not in order");

my $r10 = run_pair("server1", "client0");
ok(eq_no_ws($r10, $respawn_in_order), "server1, client0");

my $r11 = run_pair("server1", "client1");
ok(eq_no_ws(blank_req_no($r10), blank_req_no($respawn_in_order)), 
    "server1, client0");
ok($r11 ne $respawn_in_order, "server1, client1; not in order");

my $rR0 = run_pair("t_server.rb", "client0");
ok(eq_no_ws($rR0, $in_order), "Ruby Server, client0");

my $r0R = run_pair("server0", "t_client.rb");
ok(eq_no_ws(blank_req_no($r0R), blank_req_no($in_order)),
    "server0, Ruby Client");
ok($r0R ne $in_order, "server0, Ruby Client; not in order");
