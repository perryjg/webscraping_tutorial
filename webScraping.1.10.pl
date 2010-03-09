#!/usr/bin/perl -w
use strict;

#Basic built-in functions
#1. print and comment
#2. open a file.

#open file handle one > is overwrite, two >> is append
open (FILE, ">", "c:/temp/writefile.txt");


my @array=("Hello There","Mr Bond","Shaken not Stirred");

foreach my $element (@array) {
    
    print "$element\n";
    
    #print to the file
    print FILE "$element\n";
    
}

close (FILE);

open (INFILE ,"<", "c:/temp/writefile.txt");

while (<INFILE>) {
    
    
    #adding a regex match "mr"
    if($_=~/^(Mr)/) {
    
    #$1 is the first capture group, and so forth
    #put a breakpoint here. ... understand what's going on, loop through a three times. why the extra mr? OK, need an if..then
    print $1;
   
    }
}

close (INFILE);