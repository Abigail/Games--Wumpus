package Games::Wumpus::Cave;

use 5.010;

use strict;
use warnings;
no warnings 'syntax';

#
# Cave for the wumpus game.
#
#    Cave will contain rooms, and connections to various rooms.
#    Rooms may contain hazards: wumpus, bats, pits.
#

#
# Default layout is the one of a dodecahedron: vertices are rooms,
#    edges are tunnels.
#

use Games::Wumpus::Constants;
use Games::Wumpus::Room;
use Hash::Util::FieldHash qw [fieldhash];
use List::Util            qw [shuffle];

fieldhash my %rooms;      # List of rooms.
fieldhash my %wumpus;     # Location of the wumpus.
fieldhash my %start;      # Start location.
fieldhash my %location;   # Location of the player.

#
# Accessors
#
sub     rooms       {@{$rooms    {$_ [0]}}}
sub     room        {  $rooms    {$_ [0]} [$_ [1] - 1]}
sub     random_room {  $rooms    {$_ [0]} [rand @{$rooms {$_ [0]}}]}

sub     location  {  $location {$_ [0]}}
sub set_location  {  $location {$_ [0]} = $_ [1]}

sub     start     {  $start    {$_ [0]}}

#
# Construction
#
sub new {bless \do {my $var} => shift}

sub init {
    my $self = shift;

    #
    # Classical layout.
    #
    $self -> _create_rooms (scalar @CLASSICAL_LAYOUT);
    $self -> _classical_layout;

    $self -> _name_rooms;
    $self -> _create_hazards;

    if ($::DEBUG) {
        foreach my $room (@{$rooms {$self}}) {
            if ($room -> has_hazard ($WUMPUS)) {
                say "Wumpus in ", $room -> name;
            }
            if ($room -> has_hazard ($BAT)) {
                say "Bat in ", $room -> name;
            }
            if ($room -> has_hazard ($PIT)) {
                say "Pit in ", $room -> name;
            }
        }
    }

    $self;
}

#
# Create the given number of rooms. 
# Note that the rooms aren't named here, nor are either exits or hazards set.
#
sub _create_rooms {
    my $self  = shift;
    my $rooms = shift;

    $rooms {$self} = [map {Games::Wumpus::Room -> new -> init} 1 .. $rooms];

    $self;
}

#
# Create the classical layout
#
sub _classical_layout {
    my $self = shift;

     for (my $i = 0; $i < @CLASSICAL_LAYOUT; $i ++) {
        foreach my $exit (@{$CLASSICAL_LAYOUT [$i]}) {
            $rooms {$self} [$i] -> add_exit ($rooms {$self} [$exit]);
        }
     }

    $self;
}


#
# Randomly name the rooms; then store them in order.
#
sub _name_rooms {
    my $self  = shift;

    my $rooms = @{$rooms {$self}};
    my @names = shuffle 1 .. $rooms;

    for (my $i = 0; $i < @names; $i ++) {
        $rooms {$self} [$i] -> set_name ($names [$i]);
    }

    $rooms {$self} = [sort {$a -> name <=> $b -> name} @{$rooms {$self}}];

    $self;
}

#
# Assign hazards to rooms. Initially, no room will have more than one hazard.
# This method also assigns the start location (hazard free).
#
sub _create_hazards {
    my $self  = shift;

    my @rooms = shuffle @{$rooms {$self}};

   (pop @rooms) -> set_hazard ($WUMPUS) for 1 .. $NR_OF_WUMPUS;
   (pop @rooms) -> set_hazard ($PIT)    for 1 .. $NR_OF_PITS;
   (pop @rooms) -> set_hazard ($BAT)    for 1 .. $NR_OF_BATS;

    $start {$self} = pop @rooms;

    $self;
}


#
# Describe the room the player is currently in.
#
sub describe {
    my $self = shift;

    my $text;

    my $room = $self -> location;

    $text  = "You are in room " . $room -> name . ".\n";
    $text .= "I smell a Wumpus!\n" if $room -> near_hazard ($WUMPUS);
    $text .= "I feel a draft.\n"   if $room -> near_hazard ($PIT);
    $text .= "Bats nearby!\n"      if $room -> near_hazard ($BAT);

    $text .= "Tunnels lead to " . join " ", sort {$a <=> $b}
                                            map  {$_ -> name} $room -> exits;
    $text .= ".\n";

    $text;
}


#
# Return whether player can move from current destination to new location.
#
# If the current location has an exit with the given name, then yes.
#
sub can_move_to {
    my $self = shift;
    my $new  = shift;

    $self -> location -> exit_by_name ($new) ? 1 : 0;
}


#
# Move the player to a new location. Return the hazards encountered.
# Since bats may move the player, encountering a new hazard, more
# than one hazard may be encountered.
#
sub move {
    my $self = shift;
    my $new  = shift;

    my @hazards;

    $self -> set_location ($self -> room ($new));

    if ($self -> location -> has_hazard ($WUMPUS)) {
        # Death.
        return $WUMPUS;
    }
    if ($self -> location -> has_hazard ($PIT)) {
        # Death.
        return $PIT;
    }
    if ($self -> location -> has_hazard ($BAT)) {
        # Moved.
        return $BAT, $self -> move ($self -> random_room -> name);
    }

    # Nothing special.
    return;
}



__END__
