#!/usr/bin/perl
use strict;

use WWW::Mechanize;
use HTML::TableExtract;

#my $output_file = 'c:/temp/ire/car_people.csv';
my $starting_url = 'http://www.ire.org/dij/';

my $ua = WWW::Mechanize->new;
$ua->get( $starting_url );
$ua->follow_link( text => 'click here to get an index of interests.' );


$ua->follow_link( url_regex => qr/interest=CAR/ );
#open OUT, ">$output_file";


my $te = HTML::TableExtract->new;
$te->parse( $ua->content );
#print $ua->content;
#__END__

for my $table ( $te->tables ) {
    my %data;
    for my $row ( $table->rows ) {
        $data{ $row->[0] } = $row->[1];
    }
    
    print $data{ 'Name:' }, ",",
          $data{ 'Affiliation:' }, ",",
          $data{ 'Address:' }, ",",
          $data{ 'Phone:' }, ",",
          $data{ 'Interests:' }, "\n";
}
#close OUT 
