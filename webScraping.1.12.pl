#!/usr/bin/perl -w
use strict;
use LWP::Simple;

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

#what if you want to open a web page? Need to use a module.

#open my $fh, '>/home/john/tmp/ownrate.html' or die "$!";

my $url = 'http://www.census.gov/hhes/www/housing/census/historic/ownrate.html';
print getstore( $url, 'c:/temp/ownrate.html' );

open (INFILE ,"<", "c:/temp/ownrate.html") or die "$!";



while (<INFILE>) {
    
    #add another IF statement to get the homeownership rates by year
    if($_=~/HOMEOWNERSHIP RATES:\s\s(\d\d\d\d)/) {
        
        print "$1\t";
    }
    
    
    #adding a regex match "mr"
    if($_=~/^(DC)\s\s\s\s(\d\d\.\d)\%/) {
    
    #$1 is the first capture group, and so forth
    #put a breakpoint here. ... understand what's going on, loop through a three times. why the extra mr? OK, need an if..then
    print "$1\t$2\n";
    
   
    }
}

close (INFILE);