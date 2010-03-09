#!/usr/bin/perl -w This is optional in windows
use strict;

#Basic built-in functions
#1. print and comment
#2. beginning loops. This is an important one.

my @array=("Hello There","Mr Bond","Shaken not Stirred");

#foreach is another way of looping through an array. a bit easier, and is the same (functionally) as the for loop
foreach my $element (@array) {
    
    print "$element\n";
    
}


#other loops include while, do...until, etc. 