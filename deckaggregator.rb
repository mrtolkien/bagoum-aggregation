#!/usr/bin/env ruby
load 'deckparser.rb'

class DeckAgggregator
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
			puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
			puts "               AGGREGATED DECKLIST                "
			puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
				puts cleanArray(sureCards+contentiousCards)
		else
			puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
			puts "                 CARDS 100% IN                    "
			puts "                    (#{sureCards.length}) cards"
			puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
		
			puts cleanArray(sureCards)

			puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
			puts "                CONTENTIOUS CARDS                 "
			puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

			puts cleanArray(contentiousCards)
		end
	end
end

if __FILE__ == $0
	da = DeckAgggregator.new(['NiwzOjEwMTcxMzAxMCwzOjEwNjczMzAxMCwzOjEwMTcxMTA5MCwyOjEwMjcxMTAxMCwyOjEwMDcxNDAxMCwzOjEwMDcxNDAyMCwzOjEwMjcyMzAxMCwzOjEwNTcxMTAzMCwyOjEwNjcyNDAxMCwzOjEwMTcxMzA1MCwyOjEwMDcyMTAyMCwyOjEwNTcxMTAxMCwxOjEwMjAxNDAzMCwzOjEwNTcyMzAxMCwxOjEwMTc0MTAyMCwzOjEwMjczMTAzMCwxOjEwNDc0MTAxMA',
'NiwzOjEwMTcxMzAxMCwzOjEwNjczMzAxMCwzOjEwMTcxMTA5MCwyOjEwMjcxMTAxMCwyOjEwMDcxNDAxMCwzOjEwMDcxNDAyMCwzOjEwMjcyMzAxMCwzOjEwNTcxMTAzMCwyOjEwNjcyNDAxMCwzOjEwMTcxMzA1MCwyOjEwMDcyMTAyMCwyOjEwNTcxMTAxMCwxOjEwMjAxNDAzMCwzOjEwNTcyMzAxMCwxOjEwMTc0MTAyMCwzOjEwMjczMTAzMCwxOjEwNDc0MTAxMA',
'NiwyOjEwMTcxMzAxMCwzOjEwNjczMzAxMCwzOjEwMTcxMTA5MCwyOjEwMjcxMTAxMCwzOjEwNTc0MTAxMCwzOjEwMDcxNDAxMCwzOjEwMDcxNDAyMCwzOjEwMjcyMzAxMCwxOjEwNjcyNDAxMCwzOjEwMTcxMzA1MCwyOjEwMDcyMTAyMCwyOjEwNTcxMTAxMCwyOjEwMjAxNDAzMCwzOjEwNTcyMzAxMCwzOjEwMjczMTAzMCwxOjEwNDc0MTAxMCwxOjEwNjczMTAyMA',
'NiwzOjEwMTcxMzAxMCwzOjEwNjczMzAxMCwzOjEwMTcxMTA5MCwyOjEwNTc0MTAxMCwyOjEwMDcxNDAxMCwzOjEwMDcxNDAyMCwzOjEwMjcyMzAxMCwyOjEwNTcxMTAzMCwxOjEwNjcyNDAxMCwzOjEwMTcxMzA1MCwyOjEwMDcyMTAyMCwyOjEwNTcxMTAxMCwyOjEwMjAxNDAzMCwyOjEwNTcyMzAxMCwzOjEwMjczMTAzMCwyOjEwNDc0MTAxMCwxOjEwMTA0MTAxMCwxOjEwNjczMTAyMA',
'NiwyOjEwNjczMzAxMCwzOjEwMTcxMTA5MCwzOjEwMjcxMTAxMCwzOjEwMDcxNDAxMCwzOjEwMDcxNDAyMCwzOjEwMjcyMzAxMCwzOjEwNTcxMTAzMCwyOjEwNjcyNDAxMCwzOjEwMTcxMzA1MCwzOjEwNTcxMTAxMCwzOjEwMjAxNDAzMCwzOjEwNTcyMzAxMCwzOjEwMjczMTAzMCwyOjEwNDc0MTAxMCwxOjEwNjczMTAyMA',
'NiwzOjEwNjczMzAxMCwzOjEwMTcxMTA5MCwzOjEwMjcxMTAxMCwzOjEwNTc0MTAxMCwyOjEwMDcxNDAxMCwzOjEwMDcxNDAyMCwzOjEwMjcyMzAxMCwyOjEwNjcyNDAxMCwzOjEwMTcxMzA1MCwyOjEwMDcyMTAyMCwyOjEwNTcxMTAxMCwyOjEwMjAxNDAzMCwzOjEwNTcyMzAxMCwzOjEwMjczMTAzMCwyOjEwNDc0MTAxMCwxOjEwNjczMTAyMA',
'NiwzOjEwMTcxMzAxMCwzOjEwNjczMzAxMCwyOjEwMTcxMTA5MCwzOjEwMjcxMTAxMCwyOjEwNTc0MTAxMCwzOjEwMDcxNDAxMCwyOjEwMDcxNDAyMCwzOjEwMjcyMzAxMCwxOjEwNjcyNDAxMCwzOjEwMTcxMzA1MCwyOjEwMDcyMTAyMCwyOjEwNTcxMTAxMCwzOjEwMjAxNDAzMCwzOjEwNTcyMzAxMCwzOjEwMjczMTAzMCwxOjEwNDc0MTAxMCwxOjEwNjczMTAyMA',
'NiwzOjEwNjczMzAxMCwyOjEwMTcxMTA5MCwyOjEwMjcxMTAxMCwzOjEwNTc0MTAxMCwyOjEwMDcxNDAxMCwzOjEwMDcxNDAyMCwzOjEwMjcyMzAxMCwzOjEwNTcxMTAzMCwzOjEwMTcxMzA1MCwyOjEwMDcyMTAyMCwyOjEwMzczMzAxMCwzOjEwNTcyMzAxMCwzOjEwMjczMTAzMCwyOjEwNDc0MTAxMCwyOjEwNjc0MTAxMCwxOjEwNjczMTAyMCwxOjEwNDc0MTAyMA',
'NiwzOjEwNjczMzAxMCwyOjEwMTcxMTA5MCwyOjEwMjcxMTAxMCwzOjEwNTc0MTAxMCwyOjEwMDcxNDAxMCwzOjEwMDcxNDAyMCwzOjEwMjcyMzAxMCwzOjEwNTcxMTAzMCwzOjEwMTcxMzA1MCwyOjEwMDcyMTAyMCwyOjEwMzczMzAxMCwzOjEwNTcyMzAxMCwzOjEwMjczMTAzMCwyOjEwNDc0MTAxMCwyOjEwNjc0MTAxMCwxOjEwNjczMTAyMCwxOjEwNDc0MTAyMA',
'NiwzOjEwMTcxMzAxMCwzOjEwNjczMzAxMCwzOjEwMTcxMTA5MCwzOjEwMjcxMTAxMCwyOjEwNTc0MTAxMCwzOjEwMDcxNDAxMCwzOjEwMDcxNDAyMCwzOjEwMjcyMzAxMCwyOjEwNjcyNDAxMCwzOjEwMTcxMzA1MCwzOjEwNTcxMTAxMCwxOjEwMjAxNDAzMCwzOjEwNTcyMzAxMCwzOjEwMjczMTAzMCwxOjEwNDc0MTAxMCwxOjEwNjczMTAyMA',
'NiwzOjEwMTcxMzAxMCwzOjEwNjczMzAxMCwzOjEwMTcxMTA5MCwxOjEwMjcxMTAxMCwyOjEwNTc0MTAxMCwzOjEwMDcxNDAxMCwzOjEwMDcxNDAyMCwzOjEwMjcyMzAxMCwzOjEwMTcxMzA1MCwyOjEwMTAzMTAxMCwyOjEwMDcyMTAyMCwyOjEwNTcxMTAxMCwyOjEwMjAxNDAzMCwyOjEwNTcyMzAxMCwzOjEwMjczMTAzMCwyOjEwNDc0MTAxMCwxOjEwNjczMTAyMA',
'NiwzOjEwMTcxMzAxMCwzOjEwNjczMzAxMCwzOjEwMTcxMTA5MCwzOjEwMjcxMTAxMCwyOjEwNTc0MTAxMCwzOjEwMDcxNDAxMCwyOjEwMDcxNDAyMCwzOjEwMjcyMzAxMCwzOjEwMTcxMzA1MCwyOjEwMDcyMTAyMCwyOjEwNTcxMTAxMCwzOjEwMjAxNDAzMCwzOjEwNTcyMzAxMCwzOjEwMjczMTAzMCwxOjEwNDc0MTAxMCwxOjEwNjczMTAyMA',
'NiwyOjEwMTcxMzAxMCwyOjEwNjczMzAxMCwzOjEwMTcxMTA5MCwzOjEwMjcxMTAxMCwyOjEwNTc0MTAxMCwzOjEwMDcxNDAxMCwzOjEwMDcxNDAyMCwzOjEwMjcyMzAxMCwyOjEwNjcyNDAxMCwzOjEwMTcxMzA1MCwyOjEwMDcyMTAyMCwyOjEwNTcxMTAxMCwyOjEwMjAxNDAzMCwzOjEwNTcyMzAxMCwzOjEwMjczMTAzMCwxOjEwNDc0MTAxMCwxOjEwNjczMTAyMA',
'NiwzOjEwMTcxMzAxMCwzOjEwNjczMzAxMCwyOjEwMTcxMTA5MCwzOjEwMjcxMTAxMCwzOjEwNTc0MTAxMCwzOjEwMDcxNDAxMCwyOjEwMDcxNDAyMCwzOjEwMjcyMzAxMCwyOjEwMzAxMTA1MCwzOjEwMTcxMzA1MCwzOjEwNTcxMTAxMCwzOjEwMjAxNDAzMCwzOjEwNTcyMzAxMCwzOjEwMjczMTAzMCwxOjEwNjczMTAyMA',
'NiwyOjEwMTcxMzAxMCwzOjEwNjczMzAxMCwzOjEwMTcxMTA5MCwyOjEwMjcxMTAxMCwzOjEwNTc0MTAxMCwyOjEwMDcxNDAxMCwzOjEwMDcxNDAyMCwzOjEwMjcyMzAxMCwzOjEwMTcxMzA1MCwyOjEwNTcxMTAxMCwyOjEwMzczMzAxMCwzOjEwNTcyMzAxMCwzOjEwMjczMTAzMCwyOjEwNDc0MTAxMCwyOjEwNjc0MTAxMCwxOjEwNjczMTAyMCwxOjEwNDc0MTAyMA',
'NiwzOjEwNjczMzAxMCwzOjEwMTcxMTA5MCwzOjEwMjcxMTAxMCwyOjEwNTc0MTAxMCwzOjEwMDcxNDAxMCwzOjEwMDcxNDAyMCwzOjEwMjcyMzAxMCwyOjEwNjcyNDAxMCwzOjEwMTcxMzA1MCwzOjEwMDcyMTAyMCwzOjEwNTcxMTAxMCwzOjEwMjAxNDAzMCwzOjEwNTcyMzAxMCwzOjEwMjczMTAzMA',
'NiwzOjEwMTcxMzAxMCwzOjEwNjczMzAxMCwzOjEwMTcxMTA5MCwzOjEwMjcxMTAxMCwzOjEwMDcxNDAxMCwzOjEwMDcxNDAyMCwzOjEwMjcyMzAxMCwyOjEwNjcyNDAxMCwzOjEwMTcxMzA1MCwyOjEwMDcyMTAyMCwyOjEwNTcxMTAxMCwyOjEwMjAxNDAzMCwzOjEwNTcyMzAxMCwzOjEwMjczMTAzMCwxOjEwNDc0MTAxMCwxOjEwNjczMTAyMA',
'NiwzOjEwMTcxMzAxMCwzOjEwNjczMzAxMCwzOjEwMTcxMTA5MCwzOjEwMjcxMTAxMCwzOjEwMDcxNDAxMCwzOjEwMDcxNDAyMCwzOjEwMjcyMzAxMCwzOjEwNTcxMTAzMCwzOjEwMTcxMzA1MCwzOjEwNTcxMTAxMCwyOjEwMjAxNDAzMCwzOjEwNTcyMzAxMCwzOjEwMjczMTAzMCwyOjEwNDc0MTAxMA',
'NiwzOjEwMTcxMzAxMCwzOjEwNjczMzAxMCwzOjEwMTcxMTA5MCwzOjEwMjcxMTAxMCwyOjEwNTc0MTAxMCwzOjEwMDcxNDAxMCwyOjEwMDcxNDAyMCwzOjEwMjcyMzAxMCwzOjEwMTcxMzA1MCwyOjEwMDcyMTAyMCwyOjEwNTcxMTAxMCwzOjEwMjAxNDAzMCwzOjEwNTcyMzAxMCwzOjEwMjczMTAzMCwxOjEwNDc0MTAxMCwxOjEwNjczMTAyMA',
'NiwyOjEwMTcxMzAxMCwzOjEwNjczMzAxMCwzOjEwMjcxMTAxMCwzOjEwNTc0MTAxMCwyOjEwMDcxNDAxMCwzOjEwMDcxNDAyMCwzOjEwMjcyMzAxMCwzOjEwNTcxMTAzMCwzOjEwMTcxMzA1MCwyOjEwMDcyMTAyMCwyOjEwNTcxMTAxMCwxOjEwMjAxNDAzMCwzOjEwNTcyMzAxMCwzOjEwMjczMTAzMCwyOjEwNDc0MTAxMCwxOjEwNjczMTAyMCwxOjEwNDc0MTAyMA',
'NiwzOjEwMTcxMzAxMCwzOjEwNjczMzAxMCwzOjEwMTcxMTA5MCwzOjEwMjcxMTAxMCwzOjEwNTc0MTAxMCwzOjEwMDcxNDAxMCwzOjEwMDcxNDAyMCwzOjEwMjcyMzAxMCwzOjEwMTcxMzA1MCwzOjEwNTcxMTAxMCwyOjEwMjAxNDAzMCwzOjEwNTcyMzAxMCwzOjEwMjczMTAzMCwyOjEwNDc0MTAxMA',
'NiwzOjEwMTcxMzAxMCwyOjEwNjczMzAxMCwyOjEwMTcxMTA5MCwzOjEwMjcxMTAxMCwyOjEwNTc0MTAxMCwyOjEwMDcxNDAxMCwzOjEwMDcxNDAyMCwzOjEwMjcyMzAxMCwzOjEwNTcxMTAzMCwyOjEwMTcxMzA1MCwyOjEwMTAxNDAzMCwyOjEwMDcyMTAyMCwyOjEwNTcxMTAxMCwyOjEwMjAxNDAzMCwyOjEwNTcyMzAxMCwyOjEwMTc0MTAyMCwzOjEwMjczMTAzMA',
'NiwzOjEwMTcxMzAxMCwzOjEwMTcxMTA5MCwzOjEwMjcxMTAxMCwzOjEwNTc0MTAxMCwzOjEwMDcxNDAxMCwzOjEwMDcxNDAyMCwzOjEwMjcyMzAxMCwzOjEwNTcxMTAzMCwzOjEwMTcxMzA1MCwzOjEwNTcxMTAxMCwyOjEwMjAxNDAzMCwzOjEwNTcyMzAxMCwzOjEwMjczMTAzMCwyOjEwMzczMTAzMA',
'NiwzOjEwMTcxMzAxMCwzOjEwNjczMzAxMCwzOjEwMTcxMTA5MCwzOjEwNTc0MTAxMCwzOjEwMDcxNDAxMCwzOjEwMDcxNDAyMCwzOjEwMjcyMzAxMCwzOjEwNTcxMTAzMCwzOjEwMTcxMzA1MCwyOjEwMDcyMTAyMCwyOjEwNTcxMTAxMCwxOjEwMjAxNDAzMCwzOjEwNTcyMzAxMCwzOjEwMjczMTAzMCwyOjEwNDc0MTAxMA',
'NiwzOjEwMTcxMzAxMCwzOjEwNjczMzAxMCwzOjEwMTcxMTA5MCwyOjEwMjcxMTAxMCwzOjEwNTc0MTAxMCwzOjEwMDcxNDAxMCwzOjEwMDcxNDAyMCwzOjEwMjcyMzAxMCwxOjEwNTcxMTAzMCwxOjEwNjcyNDAxMCwzOjEwMTcxMzA1MCwzOjEwNTcxMTAxMCwyOjEwMjAxNDAzMCwyOjEwNTcyMzAxMCwzOjEwMjczMTAzMCwxOjEwNDc0MTAxMCwxOjEwNjczMTAyMA'
])
	da.showAggregatedList
end


	