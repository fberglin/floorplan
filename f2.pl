#!/usr/bin/perl -w

use Term::ANSIColor;

use strict;

my $black = 7 * 16;
my $grey = 7 * 16;
my $blue = 7 * 1;
my $green = 7 * 1;

my @org_tiles = ();

for my $c ("B", "G") {
    for my $i (1 ... $black) {
        push(@org_tiles, $c);
    }
}

for my $c ("L", "R") {
    for my $i (1 ... $blue) {
        push(@org_tiles, $c);
    }
}

my $cmd = 'n';
my $index = 0;
my @floors = ();
my $database = "floors.db";

if (-e $database) {
    open(DB, "< $database");
    while (<DB>) {
        $index++;
        chomp;
        my @floor = split(//);
        $floors[$index] = \@floor;
    }
}

while (1) {
    chomp($cmd);
    my @floor = ();

    if ($cmd eq 'n' or $cmd eq '') {
        @floor = ();
        $index++;
        if (not defined($floors[$index])) {
            print "New floor: $index\n";
            my @tiles = @org_tiles;
            while (@tiles) {
                my $i = int(rand(@tiles));
                my $tile = splice(@tiles, $i, 1);
                push @floor, $tile;
            }
            $floors[$index] = \@floor;
        }
    } elsif ($cmd eq "l") {
        my $input = <STDIN>;
        chomp($input);
        if (length($input) ne 7*16*2 + 7*2) {
            print "Invalid floor plan!";
            print "\n[$index/", int(@floors)-1, "] ([n]ext (b)ack (s)ave (p)rint):";
            $cmd = <STDIN>;
            next;
        }
        $index++;
        my @floor = split(//, $input);
        $floors[$index] = \@floor;
    } elsif ($cmd eq 'b') {
        if ($index > 1) {
            $index--;
        } else {
            print "No previous floor!";
            print "\n[$index/", int(@floors)-1, "] ([n]ext (b)ack (s)ave (p)rint):";
            $cmd = <STDIN>;
            next;
        }
    } elsif ($cmd =~ m(\d+)) {
        if (int($cmd) > 0 and int($cmd) < scalar(@floors)) {
            print "Going to: $cmd\n";
            $index = $cmd;
        } else {
            print "No such floor: $cmd";
            print "\n[$index/", int(@floors)-1, "] ([n]ext (b)ack (s)ave (p)rint):";
            $cmd = <STDIN>;
            next;
        }
    }

    @floor = @{$floors[$index]};

    if ($cmd eq 's') {
        foreach my $tile (@floor) {
            print $tile;
        }
        print "\n[$index/", int(@floors)-1, "] ([n]ext (b)ack (s)ave (p)rint):";
        $cmd = <STDIN>;
        next;
    } elsif ($cmd eq 'db') {
        print "Saving database to '$database'";
        open (DB, "> $database");
        foreach my $i (1 ... @floors-1) {
            @floor = @{$floors[$i]};
            print DB @floor, "\n";
        }
        close(DB);
        print "\n[$index/", int(@floors)-1, "] ([n]ext (b)ack (s)ave (p)rint):";
        $cmd = <STDIN>;
        next;
    } elsif ($cmd eq "q") {
        last;
    }

    my $count = 0;
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
            if ($count < int(@floor) - 16) {
                print "\n";
            } else {
                last;
            }
        }
    }

    print "\n[$index/", int(@floors)-1, "] ([n]ext (b)ack (s)ave (p)rint):";
    $cmd = <STDIN>;
}
