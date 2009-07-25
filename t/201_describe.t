#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no warnings 'syntax';

use Test::More 'no_plan';

BEGIN {
    use_ok 'Games::Wumpus::Cave';
    use_ok 'Games::Wumpus::Constants';
}

my $cave = Games::Wumpus::Cave -> new -> init;

isa_ok $cave, 'Games::Wumpus::Cave';

$cave -> set_location ($cave -> start);

#
# Clear the rooms of hazards.
#
$_ -> clear_hazards for $cave -> rooms;

#
# Get description for room.
#
my $desc  = $cave -> describe;
my $loc   = $cave -> location -> name;

my @exits = $cave -> location -> exits;
my @names = sort {$a <=> $b} map {$_ -> name} @exits;

ok $desc =~ /You are in room $loc\.\n/, "In the right room";
ok $desc !~ /Wumpus/i,                  "No wumpus near";
ok $desc !~ /draft/i,                   "No pit nearby";
ok $desc !~ /Bats/i,                    "No bats nearby";
ok $desc =~ /Tunnels lead to @names/,   "Tunnels ok";


#
# Create a wumpus
#
$exits [0] -> set_hazard ($WUMPUS);
   $desc  = $cave -> describe;

ok $desc =~ /You are in room $loc\.\n/, "In the right room";
ok $desc =~ /I smell a Wumpus!\n/,      "Wumpus near";
ok $desc !~ /draft/i,                   "No pit nearby";
ok $desc !~ /Bats/i,                    "No bats nearby";
ok $desc =~ /Tunnels lead to @names/,   "Tunnels ok";

#
# Create pits
#
$exits [1] -> set_hazard ($PIT);
   $desc  = $cave -> describe;

ok $desc =~ /You are in room $loc\.\n/, "In the right room";
ok $desc =~ /I smell a Wumpus!\n/,      "Wumpus near";
ok $desc =~ /I feel a draft\.\n/,       "Pits nearby";
ok $desc !~ /Bats/i,                    "No bats nearby";
ok $desc =~ /Tunnels lead to @names/,   "Tunnels ok";

#
# Create bats
#
$exits [2] -> set_hazard ($BAT);
   $desc  = $cave -> describe;

ok $desc =~ /You are in room $loc\.\n/, "In the right room";
ok $desc =~ /I smell a Wumpus!\n/,      "Wumpus near";
ok $desc =~ /I feel a draft\.\n/,       "Pits nearby";
ok $desc =~ /Bats nearby!\n/,           "Bats nearby";
ok $desc =~ /Tunnels lead to @names/,   "Tunnels ok";
