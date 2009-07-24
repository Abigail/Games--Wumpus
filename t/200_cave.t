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

my @rooms = $cave -> rooms;

is scalar @rooms, 20, "Got 20 rooms";

my %seen;
my ($wumpus, $bats, $pits, $start, $fail) = (0, 0, 0, 0, 0);
foreach my $room (@rooms) {
    my $name = $room -> name;
    ok 1 <= $name && $name <= 20, "Room name between 1 and 20";
    $seen {$name} ++;

    my @exits = $room -> exits;
    is scalar @exits, 3, "Room has three exits";

    foreach my $other (@exits) {
        my ($back) = $other -> exit_by_name ($name);
        ok  $back && $back -> name eq $name, "Exit leads back";
    }

    given ($room -> hazards) {
        when ($WUMPUS) {$wumpus ++}
        when ($BAT)    {$bats   ++}
        when ($PIT)    {$pits   ++}
        when (0)       {$start  ++ if $cave -> start eq $room}
        default        {$fail   ++}
    }

}

ok !(grep {$_ != 1} values %seen), "All names different";

is $wumpus, $NR_OF_WUMPUS, "$NR_OF_WUMPUS Wumpus";
is $bats,   $NR_OF_BATS, "$NR_OF_BATS Bats";
is $pits,   $NR_OF_PITS, "$NR_OF_PITS Pits";
is $start,  1, "1 Start location";
is $fail,   0, "No duplicates";


__END__
