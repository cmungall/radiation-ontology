#!/usr/bin/perl
while(<>) {
    chomp;
    print "$_\n";
    if (m@name: (uv.*)light(.*)@) {
        print "synonym: \"$1 $2\" EXACT []\n";
    }

}
