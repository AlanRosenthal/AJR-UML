#!/usr/bin/perl
use 5.10.0;
use strict;

use Test::Simple tests => 18;

my $ruby_src = "./ruby_basics.rb";

sub call_ruby {
    my ($code) = @_;
    my $result = `ruby -r$ruby_src -rjson -e'puts $code.to_json'`;
    chomp $result;
    return $result;
}

# Fib

ok(call_ruby("fib(1)") == 1, "fib of 1 is 1");
ok(call_ruby("fib(2)") == 1, "fib of 2 is 1");
ok(call_ruby("fib(3)") == 2, "fib of 3 is 2");
ok(call_ruby("fib(10)") == 55, "fib of 10 is 55");
ok(call_ruby("fib(30)") == 832040, "fib of 30 is 832040");

# Square List

ok(call_ruby("square_list([1,2,3])") eq "[1,4,9]", "square_list([1,2,3])");
ok(call_ruby("square_list([])") eq "[]", "square_list([])");
ok(call_ruby("square_list([22,33,55,93472])") eq "[484,1089,3025,8737014784]", 
    "square_list - list of bigger numbers");

# Map from Inject

ok(call_ruby("my_map1([1,2,3]) {|x| x+1 }") eq "[2,3,4]", "my_map1([...])");
ok(call_ruby("my_map1([]) {|x| x+1 }") eq "[]", "my_map1([])");
ok(call_ruby("my_map2([1,2,3]) {|x| x+1 }") eq "[2,3,4]", "my_map2([...])");
ok(call_ruby("my_map2([]) {|x| x+1 }") eq "[]", "my_map2([])");

# Define some classes

ok(call_ruby("[Duck, Dog].map {|kk| kk.new.speak }") eq '["Quack!","Woof!"]',
        "Ducks and dogs");

# Bananananananana

ok(call_ruby('unbanana("banana")') eq '"apple"', 'unbanana("banana")');
ok(call_ruby('unbanana("bananana ba")') eq '"apple apple"', 
    'unbanana("bananana ba")');
ok(call_ruby('unbanana("banana pancakes have banananas in them; bana")')
        eq '"apple pancakes have apples in them; apple"',
        'unbanana("banana pancakes have banananas in them; bana")');

# Tree
my $code;
$code = <<'END_RUBY';
lambda { 
  tree = Tree.new("Root",
    [Tree.new("Interior", [Tree.new("Leaf X"), Tree.new("Leaf Y")]),
     Tree.new("Leaf A")])

  names = []
  tree.visit_all {|node| names << node.node_name }
  names
}.call
END_RUBY

ok(call_ruby($code) eq '["Root","Interior","Leaf X","Leaf Y","Leaf A"]', 
    "Tree Old Form");

$code = <<'END_RUBY';
lambda { 
  tree = Tree.new(
    {"Root" => {"Interior" => {"Leaf X" => {}, "Leaf Y" => {}},
                "Leaf A" => {}}})

  names = []
  tree.visit_all {|node| names << node.node_name }
  names
}.call
END_RUBY

ok(call_ruby($code) eq '["Root","Interior","Leaf X","Leaf Y","Leaf A"]', 
    "Tree New Form");
