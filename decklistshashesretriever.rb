#!/usr/bin/env ruby
load 'deckaggregator.rb'
require 'nokogiri'
require 'nokogiri'
require 'open-uri'


class DecklistsHashesRetreiver
	#@archetypeName is the name of the archetype on Bagoum
	#@tournaments : 0 for JCG, 1 for NGE, 2 for both
	#@format : 0 for rotation, 1 for unlimited
	
	# Defaults are as followed :
	# Last 3 weeks
	# Only JCG (usually more data, so more accurate)
	# Rotation
	def initialize(archetypeName, tournaments=0, maxDate=Date.today-21, format=0)
		@archetypeName = archetypeName
		@tournaments = tournaments
		@maxDate=maxDate
		@format = format
	end
	
	def getDecklistsHashes
		# Our future result
		decklistHashes=Array.new
		
		#If we have either JCG only or JCG and NGE, meaning tournament=0 or 2
		if @tournaments%2==0
			decklistHashes=parseDecklistsFrompage('https://sv.bagoum.com/deckdumpj')
		end
		
		#If we have either NGE only or JCG and NGE, meaning tournament=1or2
		if @tournaments>0
			decklistHashes=decklistHashes+parseDecklistsFrompage('https://sv.bagoum.com/deckdump')
		end
		
		puts "#{decklistHashes.length} decklists founds."
		
		decklistHashes
	end
	
	def parseDecklistsFrompage(pageURL)
		decklistHashes=Array.new
		doc = Nokogiri::HTML(open(pageURL))
		
		if @format==1
			decklistLinks =  doc.css('a.dsr.dsr-unltd')
		end
		
		if @format==0
			decklistLinks =  doc.css('a.dsr')
			decklistLinks = decklistLinks.search('a.dsr.dsr-unltd').remove
		end
		
		decklistLinks.each do |link|
			#Here is the selection of the wanted decks
			if link['data-arch']==@archetypeName && Date.parse(link['data-date'])>@maxDate
				decklistHashes.push(link['href'].sub("/deckbuilder#","").gsub!(/[^0-9A-Za-z]/, ''))
			end
		end
				
		decklistHashes
	end
end

#Code to test the file/use it by itself
if __FILE__ == $0
	dhr = DecklistsHashesRetreiver.new('Midrange Shadow', 0, Date.parse("2018-1-3"), 0)
	da=DeckAggregator.new(dhr.getDecklistsHashes)
	da.showAggregatedList
end