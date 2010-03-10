#!/usr/bin/env ruby
require 'rubygems'
require 'mechanize'
require 'hpricot'
require 'date'
require 'time'
require 'logger'
require 'dbi'
require 'singleton'

class VoteScraper
  include Singleton
  
  def self.scrape( house )
    ##### establish DB connection ##############################################
    dbh = DBI.connect( "DBI:Mysql:newsroom_datawarehouse:fcp-intradevsql1",
                       "nrdw_a",
                       "12Store21" )
    
    @insert_sql = 'INSERT IGNORE INTO legis_votes_master_test
                   ( vote_id, house, date, type, num, description, yea, nay, not_voting, excused )
                   VALUES("%s","%s","%s","%s","%s","%s","%s","%s","%s","%s")'
    
    votes_master_fields = %w[ vote_id house date type num description yea nay not_voting excused ]
    rec_count = 0
    ############################################################################
    
    my_logger = Logger.new(STDERR)
    my_logger.level = Logger::INFO
    house_page = { 'H' => 'hvotes.htm', 'S' => 'svotes.htm' }
    
    ua = Mechanize.new {|a| a.log = my_logger }
    page = ua.get( "http://www.legis.ga.gov/legis/2009_10/votes/#{house_page[house]}" )
    
    page.links_with( :href => %r{(h|s)\d+\.htm} ).each do |link|
      sleep( 1 )
      vote_page = link.click()
      
      doc = Hpricot.parse( vote_page.body )
      (doc/"//tr").each do |row|
        next unless (row/"//td[@class=legislation]").inner_text =~ /\w/
        next if (row/"//td[@class=date]").inner_text =~ /2009/
        
        # get vote row info
        my_logger.info(  (row/"//td[@class=number]").inner_text )
        vote = Hash.new
        vote['vote_id'] = (row/"//td[@class=number]").inner_text
        vote['house'] = house
        ( vote['type'], vote['num'] ) = (row/"//td[@class=legislation]").inner_text.match(/([HS][BR]) (\d+)/).captures
        date = Date::parse( (row/"//td[@class=date]").inner_text, comp=true ).to_s
        time = Time::parse( (row/"//td[@class=time]").inner_text ).strftime( '%H:%M:%S' )
        vote['date'] = date + ' ' + time
        vote['description'] = (row/"//td[@class=caption]").inner_text
        
        # jump to vote detail page
        sleep( 2 )
        vote_number = (row/"//td[@class=number]").inner_text
        
        begin
          rollcall_page = vote_page.link_with( :text => vote_number ).click
        rescue Timeout::Error 
          my_logger.error( "Timeout Error: vote # #{votenumber} skipped" )
          next
        end
        
        rollcall_doc = Hpricot.parse( rollcall_page.body )
        
        # get vote summaru info
        vote['yea'] = (rollcall_doc/"*/div[@id=totals]/span[@id='yea']").inner_text
        vote['nay'] = (rollcall_doc/"*/div[@id=totals]/span[@id='nay']").inner_text
        vote['not_voting'] = (rollcall_doc/"*/div[@id=totals]/span[@id='not-voting']")[0].inner_text
        vote['excused'] = (rollcall_doc/"*/div[@id=totals]/span[@id='not-voting']")[1].inner_text
        
        # db insert statement
        sql_statement = @insert_sql % votes_master_fields.map { |key| vote[key] }
        my_logger.debug( sql_statement )
        
        begin
          inserted = dbh.do( sql_statement )
          my_logger.info( "Vote #{vote['vote_id']} record inserted" ) if inserted > 0
          rec_count += inserted
        rescue DBI::DatabaseError => e
          my_logger.error( e.errstr )
          my_logger.error( e.state )
        rescue => e
          my_logger.error( e.message )
          my_logger.error( sprintf( insert_sql, values ) )
        end
      end
    end
    
    my_logger.info( "Records inserted: #{rec_count}" )
    dbh.disconnect
  end
end

VoteScraper.scrape('H')
VoteScraper.scrape('S')
