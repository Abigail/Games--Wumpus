#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no warnings 'syntax';

use Test::More 'no_plan';

BEGIN {
    use_ok 'Games::Wumpus::Room';
}

my $room = Games::Wumpus::Room -> new -> init;

isa_ok $room, 'Games::Wumpus::Room';

ok $room -> set_name ("Room name"), "Set room name";
is $room -> name, "Room name", "Get room name";

is  $room -> hazards, 0, "No hazards set";
ok  $room -> set_hazard (2), "Set hazard";
is  $room -> hazards, 2, "One hazard set";
ok  $room -> set_hazard (4), "Set hazard";
is  $room -> hazards, 6, "Two hazards set";
ok  $room -> set_hazard (4), "Set hazard";
is  $room -> hazards, 6, "Two hazards set";
ok  $room -> has_hazard (2), "Has hazard";
ok !$room -> has_hazard (1), "Does not have hazard";
ok  $room -> clear_hazard (2), "Clear hazard";
is  $room -> hazards, 4, "One hazard set";
is  $room -> clear_hazards, 0, "Cleared all hazard";
is  $room -> hazards, 0, "No hazards set";

is  scalar $room -> exits, 0, "No exits";
ok  $room -> add_exit (bless \do {my $x = "one"}), "Add exit";
ok  $room -> add_exit (bless \do {my $x = "two"}), "Add exit";
is  scalar $room -> exits, 2, "Two exits";
is  scalar $room -> exit_by_name ("one"), 1, "Got exit";
is  scalar $room -> exit_by_name ("two"), 1, "Got exit";
is  scalar $room -> exit_by_name ("three"), 0, "Didn't get exit";


sub name {${$_ [0]}}

__END__
