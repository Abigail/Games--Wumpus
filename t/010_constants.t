#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no warnings 'syntax';

use Test::More 'no_plan';

BEGIN {
    use_ok 'Games::Wumpus::Constants';
}

is $WUMPUS, 1, '$WUMPUS';
is $BAT,    2, '$BAT';
is $PIT,    4, '$PIT';

is $NR_OF_WUMPUS, 1, '$NR_OF_WUMPUS';
is $NR_OF_BATS,   2, '$NR_OF_BATS';
is $NR_OF_PITS,   2, '$NR_OF_PITS';
is $NR_OF_ARROWS, 5, '$NR_OF_ARROWS';

is scalar @HAZARDS, 3, "3 Hazards";
ok grep ({$_ == $WUMPUS} @HAZARDS), "Wumpus is a hazard";
ok grep ({$_ == $BAT   } @HAZARDS), "Bat is a hazard";
ok grep ({$_ == $PIT   } @HAZARDS), "Pit is a hazard";

__END__
