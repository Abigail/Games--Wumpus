package Games::Wumpus::Room;

use 5.010;

use strict;
use warnings;
no warnings 'syntax';

#
# Room in the cave of a Wumpus game.
#

use Hash::Util::FieldHash qw [fieldhash];
use Games::Wumpus::Constants;

fieldhash my %name;    # 'Name' of the room; typically a positive integer.
fieldhash my %hazard;  # 'Hazards' the room may contain.
fieldhash my %exit;    # 'Tunnels' to other rooms. List of objects.

sub new  {bless \do {my $var} => shift}

sub init {
    my $self = shift;

    $hazard {$self} = 0;
    $exit   {$self} = [];

    $self;
}

#
# Accessors
#
sub   set_name         {$name   {$_ [0]}  =  $_ [1]; $_ [0]}
sub       name         {$name   {$_ [0]}}

sub   set_hazard       {$hazard {$_ [0]} |=  $_ [1]; $_ [0]}
sub       hazards      {$hazard {$_ [0]}}
sub clear_hazard       {$hazard {$_ [0]} &= ~$_ [1]; $_ [0]}
sub clear_hazards      {$hazard {$_ [0]}  =  0;      $_ [0]}
sub   has_hazard       {$hazard {$_ [0]} &   $_ [1]}

sub   add_exit         {push @{$exit {$_ [0]}} => $_ [1]; $_ [0]}
sub       exits        {     @{$exit {$_ [0]}}}
sub       exit_by_name {
    my $self = shift;
    my $name = shift;
    my ($e)  = grep {$_ -> name eq $name} $self -> exits;
    return $e;
}

#
# Hazards nearby?
#

sub near_hazard {
    my $self   = shift;
    my $hazard = shift;
    foreach my $exit ($self -> exits) {
        return 1 if $exit -> has_hazard ($hazard);
    }
    return 0;
}

1;

__END__
