#!/usr/bin/env ruby
load 'deckparser.rb'

class DeckAggregator
	#@deckNames is the array of Bagoum IDs
	#@cardsOccurences is the array containing all the cards and the time they appear in the decklists
	#@sureCards is the list of cards that are 100% in (occurences > occurences of 40th card)
	#@contentiousCards is the list of cards that have the same number of occurences as the 40th card
	#@dismissedCards are the cards that appear rarely enough to be dismissed
	attr_accessor :deckNames
	attr_accessor :sureCards
	attr_accessor :contentiousCards
	attr_accessor :dismissedCards
	
	def initialize(deckNames)
		@deckNames = deckNames
	end
	
	def createOccurencesList
		@cardsOccurences=Hash.new
		@deckNames.each do |deckName|
			decklist=(DeckParser.new(deckName)).decklistKarsten
			decklist.each do |card|
				if @cardsOccurences[card].nil?
					@cardsOccurences[card]=1
				else
					@cardsOccurences[card]=@cardsOccurences[card]+1
				end
			end
		end
	end
	
	def calculateDecklist
		@sureCards=Array.new
		@contentiousCards=Array.new
		@dismissedCards=Array.new
		
		createOccurencesList
		
		sortedOccurences=@cardsOccurences.sort_by{|k,v| v}.reverse
		
		#Pass through the array to get the 40th card and its occurences. There is likely a clean way to do it, but I don't know enough about Ruby yo
		i=0
		sortedOccurences.each do |cardName, occurence|
			i=i+1
			if i==40
				@minOccurence=occurence
			end
		end
		
		puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
		puts "                    RAW DATA                      "
		puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
		puts sortedOccurences
		
		sortedOccurences.each do |cardName, occurence|
			if occurence>@minOccurence
				sureCards.push(cardName)
			elsif occurence==@minOccurence
				contentiousCards.push(cardName)
			elsif occurence<@minOccurence
				dismissedCards.push(cardName)
			end
		end
	end
	
	def cleanArray(array)
		cleanedList=Hash.new
		cleanedArray=Array.new
		
		array.each do |card|
			cardName=card.chop
			if cleanedList[cardName].nil?
				cleanedList[cardName]=1
			else
				cleanedList[cardName]=cleanedList[cardName]+1
			end
		end
		
		cleanedList.each do |card, number|
			cleanedArray.push("#{card} x #{number}")
		end
		
		cleanedArray.sort!
	end
	
	def showAggregatedList
		calculateDecklist
				
		#if we have exactly 40 cards, no need to print the "contentious" cards separately
		if contentiousCards.length+sureCards.length==40
			puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
			puts "              AGGREGATED DECKLIST                "
			puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
				puts cleanArray(sureCards+contentiousCards)
		else
			puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
			puts "                CARDS 100% IN                    "
			puts "                  (#{sureCards.length}) cards"
			puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
		
			puts cleanArray(sureCards)

			puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
			puts "               CONTENTIOUS CARDS                 "
			puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

			puts cleanArray(contentiousCards)
		end
	end
end

if __FILE__ == $0
	da = DeckAggregator.new(['NSwzOjEwMTYxMTA0MCwzOjEwMTYxMTA1MCwzOjEwMzYxMTAzMCwzOjEwNDYxMTAyMCwzOjEwMDYxNDAyMCwyOjEwMzYyNDAxMCwyOjEwMzAxMTA1MCwyOjEwNjAyMTAyMCwyOjEwNzYxMTAyMCwzOjEwMDYxMTA1MCwzOjEwNDY0MTAxMCwzOjEwNDYyMTA0MCwzOjEwNTYyMTAxMCwzOjEwMTYzNDAxMCwyOjEwNTYzMTAxMA',
'NSwzOjEwMTYxMTA0MCwzOjEwMTYyMTA2MCwzOjEwMTYxMTA1MCwzOjEwMzYxMTAzMCwzOjEwNDYxMTAyMCwzOjEwMDYxNDAyMCwyOjEwMzYyNDAxMCwzOjEwNjAyMTAyMCwzOjEwNzYxMTAyMCwzOjEwMDYxMTA1MCwzOjEwNDY0MTAxMCwxOjEwMjAxNDAzMCwyOjEwNTYyMTAxMCwzOjEwMTYzNDAxMCwyOjEwNTYzMTAxMA',
'NSwzOjEwMTYxMTA0MCwzOjEwMTYxMTA1MCwzOjEwMzYxMTAzMCwzOjEwNDYxMTAyMCwzOjEwMDYxNDAyMCwyOjEwMzYyNDAxMCwzOjEwMzAxMTA1MCwyOjEwNjAyMTAyMCwyOjEwNzYxMTAyMCwzOjEwMDYxMTA1MCwzOjEwNDY0MTAxMCwzOjEwNDYyMTA0MCwyOjEwNTYyMTAxMCwzOjEwMTYzNDAxMCwyOjEwNTYzMTAxMA',
'NSwzOjEwMTYxMTA0MCwzOjEwMTYyMTA2MCwzOjEwMTYxMTA1MCwzOjEwMzYxMTAzMCwzOjEwNDYxMTAyMCwzOjEwMDYxNDAyMCwyOjEwMzYyNDAxMCwzOjEwNjAyMTAyMCwzOjEwNzYxMTAyMCwzOjEwMDYxMTA1MCwzOjEwNDY0MTAxMCwzOjEwNTYyMTAxMCwzOjEwMTYzNDAxMCwyOjEwNTYzMTAxMA',
'NSwzOjEwMTYxMTA0MCwzOjEwMTYxMTA1MCwzOjEwMzYxMTAzMCwzOjEwNDYxMTAyMCwzOjEwMDYxNDAyMCwyOjEwMzYyNDAxMCwzOjEwNjAyMTAyMCwzOjEwNzYxMTAyMCwzOjEwMDYxMTA1MCwzOjEwNDY0MTAxMCwzOjEwNDYyMTA0MCwyOjEwNTYyMTAxMCwzOjEwMTYzNDAxMCwzOjEwNTYzMTAxMA',
'NSwzOjEwMTYxMTA0MCwzOjEwMTYxMTA1MCwzOjEwMzYxMTAzMCwzOjEwNDYxMTAyMCwzOjEwMDYxNDAyMCwyOjEwMzYyNDAxMCwyOjEwNDYyMzAxMCwzOjEwNjAyMTAyMCwyOjEwNzYxMTAyMCwzOjEwMDYxMTA1MCwzOjEwNDY0MTAxMCwzOjEwNDYyMTA0MCwyOjEwNTYyMTAxMCwzOjEwMTYzNDAxMCwyOjEwNTYzMTAxMA',
'NSwzOjEwMTYxMTA0MCwzOjEwMTYyMTA2MCwzOjEwMTYxMTA1MCwzOjEwMzYxMTAzMCwzOjEwNDYxMTAyMCwzOjEwMDYxNDAyMCwyOjEwMzYyNDAxMCwzOjEwNjAyMTAyMCwzOjEwNzYxMTAyMCwzOjEwMDYxMTA1MCwzOjEwNDY0MTAxMCwxOjEwMjAxNDAzMCwyOjEwNTYyMTAxMCwzOjEwMTYzNDAxMCwyOjEwNTYzMTAxMA',
'NSwzOjEwMTYxMTA0MCwzOjEwMTYyMTA2MCwzOjEwMTYxMTA1MCwzOjEwMzYxMTAzMCwzOjEwNDYxMTAyMCwzOjEwMDYxNDAyMCwyOjEwMzYyNDAxMCwzOjEwNjAyMTAyMCwzOjEwNzYxMTAyMCwzOjEwMDYxMTA1MCwzOjEwNDY0MTAxMCwyOjEwNTYyMTAxMCwzOjEwMTYzNDAxMCwzOjEwNTYzMTAxMA',
'NSwzOjEwMTYxMTA0MCwzOjEwMTYxMTA1MCwzOjEwMzYxMTAzMCwzOjEwNDYxMTAyMCwzOjEwMDYxNDAyMCwyOjEwMzYyNDAxMCwzOjEwMzAxMTA1MCwyOjEwNjAyMTAyMCwxOjEwNTYxMTAxMCwzOjEwMDYxMTA1MCwzOjEwNDY0MTAxMCwzOjEwNDYyMTA0MCwyOjEwNTYyMTAxMCwzOjEwMTYzNDAxMCwxOjEwNTY0MTAxMCwyOjEwNTYzMTAxMA',
'NSwzOjEwMTYxMTA0MCwzOjEwMTYyMTA2MCwzOjEwMTYxMTA1MCwzOjEwMzYxMTAzMCwzOjEwNDYxMTAyMCwzOjEwMDYxNDAyMCwyOjEwMzYyNDAxMCwzOjEwNjAyMTAyMCwzOjEwNzYxMTAyMCwzOjEwMDYxMTA1MCwzOjEwNDY0MTAxMCwzOjEwNTYyMTAxMCwzOjEwMTYzNDAxMCwyOjEwNTYzMTAxMA',
'NSwzOjEwMTYxMTA0MCwzOjEwMTYyMTA2MCwzOjEwMTYxMTA1MCwzOjEwMzYxMTAzMCwzOjEwNDYxMTAyMCwzOjEwMDYxNDAyMCwyOjEwMzYyNDAxMCwxOjEwMzAxMTA1MCwyOjEwNjAyMTAyMCwzOjEwNzYxMTAyMCwzOjEwMDYxMTA1MCwzOjEwNDY0MTAxMCwzOjEwNTYyMTAxMCwzOjEwMTYzNDAxMCwyOjEwNTYzMTAxMA',
'NSwzOjEwMDAxMTAxMCwzOjEwMTYxMTA0MCwxOjEwMTYyMTA2MCwzOjEwMTYxMTA1MCwzOjEwMzYxMTAzMCwzOjEwNDYxMTAyMCwzOjEwNDYyMTAyMCwzOjEwMDYxNDAyMCwyOjEwMzYyNDAxMCwyOjEwNjAyMTAyMCwyOjEwNzYxMTAyMCwzOjEwMDYxMTA1MCwzOjEwNDY0MTAxMCwyOjEwNTYyMTAxMCwyOjEwMTYzNDAxMCwyOjEwNTY0MTAxMA',
'NSwzOjEwMDAxMTAxMCwzOjEwMTYxMTA0MCwxOjEwMTYyMTA2MCwzOjEwMTYxMTA1MCwzOjEwMzYxMTAzMCwzOjEwNDYxMTAyMCwzOjEwNDYyMTAyMCwzOjEwMDYxNDAyMCwyOjEwMzYyNDAxMCwxOjEwNjAyMTAyMCwzOjEwNzYxMTAyMCwzOjEwMDYxMTA1MCwzOjEwNDY0MTAxMCwyOjEwNTYyMTAxMCwyOjEwMTYzNDAxMCwyOjEwNTY0MTAxMA'
])
	da.showAggregatedList
end


	