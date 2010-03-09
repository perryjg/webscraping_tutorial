#!/usr/bin/perl -w This is optional in windows
use strict;

#Basic built-in functions
#1. print and comment
#2. beginning variables.. very simple scalar variable

my $scalar="Hello There";
print "$scalar";


#perl is a loosly typed language, meaning it will convert based on the context
my $int=1;
my $str="1";

print $int+$str;