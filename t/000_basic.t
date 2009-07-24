#!/usr/bin/perl

use 5.006;

use strict;
use warnings;
no  warnings 'syntax';

use Test::More tests => 2;

BEGIN {
    use_ok ('Games::Wumpus');
}

ok defined $Games::Wumpus::VERSION, "VERSION is set";
