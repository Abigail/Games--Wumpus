#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no warnings 'syntax';

use Test::More tests => 7;

BEGIN {
    use_ok 'Games::Wumpus';
    use_ok 'Games::Wumpus::Cave';
    use_ok 'Games::Wumpus::Room';
    use_ok 'Games::Wumpus::Constants';
}

is $Games::Wumpus::Cave::VERSION,      $Games::Wumpus::VERSION, "VERSION check";
is $Games::Wumpus::Room::VERSION,      $Games::Wumpus::VERSION, "VERSION check";
is $Games::Wumpus::Constants::VERSION, $Games::Wumpus::VERSION, "VERSION check";


__END__
