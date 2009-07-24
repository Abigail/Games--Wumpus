package Games::Wumpus::Constants;

use 5.010;

use strict;
use warnings;
no warnings 'syntax';

#
# Contants used in the Wumpus game.
#

use Exporter ();
our @ISA    = 'Exporter';
our @EXPORT = qw [
    $WUMPUS $BAT $PIT
    $NR_OF_WUMPUS $NR_OF_BATS $NR_OF_PITS $NR_OF_ARROWS
    @CLASSICAL_LAYOUT
];

#
# Hazards
#
our $WUMPUS        = 1 << 0;
our $BAT           = 1 << 1;;
our $PIT           = 1 << 2;;

our $NR_OF_WUMPUS  = 1;
our $NR_OF_BATS    = 2;
our $NR_OF_PITS    = 2;
our $NR_OF_ARROWS  = 5;

our $WUMPUS_MOVES  = .75;   # Change of Wumpus moving when woken up.

#
# Classical
#
our @CLASSICAL_LAYOUT = (
    [ 1,  4,  7], [ 0,  2,  9], [ 1,  3, 11], [ 2,  4, 13],
    [ 0,  3,  5], [ 4,  6, 14], [ 5,  7, 16], [ 0,  6,  8],
    [ 7,  9, 17], [ 1,  8, 10], [ 9, 11, 18], [ 2, 10, 12],
    [11, 13, 19], [ 3, 12, 14], [ 5, 13, 15], [14, 16, 19],
    [ 6, 15, 17], [ 8, 16, 18], [10, 17, 19], [12, 15, 18],
);


1;

__END__
