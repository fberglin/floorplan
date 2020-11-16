#!/usr/bin/perl -w

use Term::ANSIColor;

# vim: ts=4:sw=4:expandtab

use strict;

my $black = 7 * 16;
my $grey = 7 * 16;
my $blue = 7 * 1;
my $green = 7 * 1;

my @tiles = ();
my @floor = ();

for my $c ("B", "G") {
    for my $i (1 ... $black) {
        push(@tiles, $c);
    }
}

for my $c ("L", "R") {
    for my $i (1 ... $blue) {
        push(@tiles, $c);
    }
}

while (@tiles) {
    my $index = int(rand(@tiles));
    # print $index, ":", @tiles, ":";
    my $tile = splice(@tiles, $index, 1);
    # print $tile, "\n";
    push @floor, $tile;
}

my $count = 0;
# $Term::ANSIColor::EACHLINE = "\n";
foreach my $tile (@floor) {
    $count++;
    if ($tile eq "B") {
        print color('on_bright_black'), " ";
        print color('on_bright_black'), " ";
    } elsif ($tile eq "G") {
        print color('on_white'), " ";
        print color('on_white'), " ";
    } elsif ($tile eq "L") {
        print color('on_cyan'), " ";
        print color('on_cyan'), " ";
    } elsif ($tile eq "R") {
        print color('on_bright_green'), " ";
        print color('on_bright_green'), " ";
    }
    print color('on_black');
    if ($count % 16 == 0) {
        print "\n";
    }
}
print "\n";
