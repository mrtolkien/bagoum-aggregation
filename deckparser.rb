#!/usr/bin/env ruby
require 'httparty'

class DeckParser
	#@deckID is the ID of the deck on Bagoum
	#@deckJSON is the JSON gotten from /expandh
	#@decklistKarsten is the decklist with different entries for 1st, 2nd, and 3rd copies of a card.
	attr_accessor :decklistKarsten
 
	def initialize(deckID)
		@deckID = deckID
		parseJSON
		puts "Deck parsed"
	end
 
	def getJSON
		url = 'https://sv.bagoum.com/expandh/'+@deckID
		response = HTTParty.get(url)
		@deckJSON=response.parsed_response
	end
	
	def parseJSON
		getJSON
		@decklistKarsten=Array.new
		@deckJSON.each do |card|
			if card.respond_to?("each")
				for i in 1..card["count"]
					@decklistKarsten.push("#{card["name"]}#{i}")
				end
			end
		end
	end
end

if __FILE__ == $0
	dp=DeckParser.new('MiwzOjEwMTAyNDAxMCwzOjEwMDMxNDAxMCwzOjEwNjMxMTAzMCwzOjEwMDMxNDAyMCwyOjEwMDMxNDAzMCwyOjEwMDMxNDA0MCwzOjEwMTMxNDAxMCwzOjEwNTMzNDAxMCwyOjEwMTMyNDA0MCwzOjEwNjMyNDAxMCwzOjEwMTMxNDAyMCwzOjEwMDMxNDA3MCwzOjEwNDMyMTA0MCwxOjEwNjM0MTAyMCwzOjEwMTMzNDAyMA')
	
	puts dp.decklistKarsten
end