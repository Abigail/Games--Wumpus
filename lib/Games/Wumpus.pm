package Games::Wumpus;

use 5.010;
use strict;
use warnings;
no  warnings 'syntax';

our $VERSION = '2009072401';

use Hash::Util::FieldHash qw [fieldhash];

use Games::Wumpus::Constants;
use Games::Wumpus::Cave;
use Games::Wumpus::Room;

fieldhash my %cave;
fieldhash my %arrows;
fieldhash my %finished;

sub new  {bless \do {my $var} => shift}
sub init {
    my $self = shift;

    $cave     {$self} = Games::Wumpus::Cave -> new -> init;
    $arrows   {$self} = $NR_OF_ARROWS;

    $cave     {$self} -> set_location ($cave {$self} -> start);

    $self;
}

#
# Accessors
#
sub cave       {   $cave     {$_ [0]}}
sub arrows     {   $arrows   {$_ [0]}}
sub lose_arrow {-- $arrows   {$_ [0]}}
sub finished   {   $finished {$_ [0]}}
sub win        {   $finished {$_ [0]} = 1}
sub lose       {   $finished {$_ [0]} = 0}


#
# Describe the current situation
#
sub describe {
    my $self = shift;
    
    my $text = $self -> cave -> describe;
    $text .= "You have " . $self -> arrows . " arrows left.\n";

    $text;
}

#
# Try to move a different room. The argument is well formatted, 
# but not necessarely valid.
#
sub move {
    my $self = shift;
    my $new  = shift;

    unless ($self -> cave -> can_move_to ($new)) {
        return (0, "There's no tunnel to $new\n");
    }

    my @hazards = $self -> cave -> move ($new);

    my @messages;
    foreach (@hazards) {
        when ($WUMPUS) {
            $self -> lose;
            push @messages => "Oops! Bumped into a Wumpus!";
        }
        when ($PIT) {
            $self -> lose;
            push @messages => "YYYIIIIEEEE! Fell in a pit!";
        }
        when ($BAT) {
            push @messages => "ZAP! Super bat snatch! Elsewhereville for you!";
        }
    }
    return 1, @messages;

}


#
# Try to move a different room. The argument is well formatted, 
# but not necessarely valid.
#
sub shoot {
    my $self  = shift;
    my @rooms = @_;

    if ($self -> arrows < 1) {
        #
        # This shouldn't be able to happen.
        #
        $self -> lose;
        return 0, "You are out of arrows";
    }

    for (my $i = 2; $i < @rooms; $i ++) {
        if ($rooms [$i] eq $rooms [$i - 2]) {
            return 0, "Arrows aren't that crooked - try another path";
        }
    }

    my $hit = $self -> cave -> shoot (@rooms);

    my @mess;
    given ($hit) {
        when ($WUMPUS) {
            $self -> win;
            return 1, "Ha! You got the Wumpus!";
        }
        when ($PLAYER) {
            $self -> lose;
            return 1, "Ouch! Arrow got you!";
        }
        default {
            push @mess => "Missed";
        }
    }

    $self -> cave -> stir_wumpus;

    if ($self -> cave -> wumpus == $self -> cave -> location) {
        $self -> lose;
        return 1, @mess, "Tsk Tsk Tsk - Wumpus got you!";
    }

    if ($self -> lose_arrow < 1) {
        return 1, @mess,
                 "You ran out of arrows. Wumpus will eventually eat you."
    }
}


1;

__END__

=head1 NAME

Games::Wumpus - Abstract

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 BUGS

=head1 TODO

=head1 SEE ALSO

=head1 DEVELOPMENT

The current sources of this module are found on github,
L<< git://github.com/Abigail/games--wumpus.git >>.

=head1 AUTHOR

Abigail, L<< mailto:cpan@abigail.be >>.

=head1 COPYRIGHT and LICENSE

Copyright (C) 2009 by Abigail.

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),   
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHOR BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

=head1 INSTALLATION

To install this module, run, after unpacking the tar-ball, the 
following commands:

   perl Makefile.PL
   make
   make test
   make install

=cut
