#!/usr/bin/perl
while(<>) {
    chomp;
    print "$_\n";
    if (m@name: (uv.*)\s+light\s+(.*)@i) {
        print "synonym: \"$1 $2\" EXACT []\n";
    }

}
