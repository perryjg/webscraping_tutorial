#!/usr/bin/perl
use strict;

use WWW::Mechanize;
use HTML::TableExtract;

my $output_file = 'c:/temp/ire/car_people.csv';
my $starting_url = 'http://www.okiecar.org/nerds';

my $ua = WWW::Mechanize->new;
$ua->get( $starting_url );

open OUT, ">$output_file";

$ua->form_name( 'byState' );
$ua->set_fields( state => 'TX' );
$ua->click;


my $te = HTML::TableExtract->new;
$te->parse( $ua->content );

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
close OUT 
