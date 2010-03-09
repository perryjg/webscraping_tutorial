#!/usr/bin/perl -w
use strict;

#Basic built-in functions
#1. print and comment
#2. open a file.

#open file handle
open (FILE, ">>", "c:/temp/writefile.txt");


my @array=("Hello There","Mr Bond","Shaken not Stirred");

foreach my $element (@array) {
    
    print "$element\n";
    
    #print to the file
    print FILE "$element\n";
    
}


close (FILE);