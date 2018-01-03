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
	
	def showAggregatedList
		calculateDecklist
		
		puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
		puts "            HERE ARE THE CARDS 100% IN            "
		puts "                    (#{sureCards.length}) cards"
		puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
		
		puts sureCards
		
		puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
		puts "          HERE ARE THE CONTENTIOUS CARDS          "
		puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

		puts contentiousCards
	end
end

if __FILE__ == $0
	da = DeckAgggregator.new(['MiwzOjEwMTAyNDAxMCwzOjEwMDMxNDAxMCwyOjEwNjMxMTAzMCwzOjEwMDMxNDAyMCwzOjEwMDMxNDAzMCwzOjEwMDMxNDA0MCwzOjEwMTMxNDAxMCwyOjEwNTMzNDAxMCwyOjEwMTMyNDA0MCwzOjEwNjMyNDAxMCwzOjEwMTMxNDAyMCwyOjEwMDMxNDA3MCwzOjEwNDMyMTA0MCwyOjEwNjM0MTAyMCwzOjEwMTMzNDAyMA',
	'MiwzOjEwMTAyNDAxMCwzOjEwMDMxNDAxMCwyOjEwMTMyNDAzMCwzOjEwNjMxMTAzMCwzOjEwMDMxNDAyMCwzOjEwMDMxNDA0MCwzOjEwMTMxNDAxMCwzOjEwNTMzNDAxMCwyOjEwMTMyNDA0MCwyOjEwNjMyNDAxMCwzOjEwMTMxNDAyMCwyOjEwMDMxNDA3MCwzOjEwNDMyMTA0MCwyOjEwNjM0MTAyMCwzOjEwMTMzNDAyMA',
	'MiwzOjEwMTAyNDAxMCwzOjEwMDMxNDAxMCwxOjEwMTMyNDAzMCwzOjEwNjMxMTAzMCwzOjEwMDMxNDAyMCwzOjEwMDMxNDA0MCwzOjEwMTMxNDAxMCwzOjEwNTMzNDAxMCwyOjEwMTMyNDA0MCwzOjEwNjMyNDAxMCwzOjEwMTMxNDAyMCwyOjEwMDMxNDA3MCwzOjEwNDMyMTA0MCwyOjEwNjM0MTAyMCwzOjEwMTMzNDAyMA',
	'MiwzOjEwMTAyNDAxMCwzOjEwMDMxNDAxMCwyOjEwMTMyNDAzMCwzOjEwNjMxMTAzMCwzOjEwMDMxNDAyMCwyOjEwMDMxNDAzMCwyOjEwMDMxNDA0MCwyOjEwMTMxNDAxMCwzOjEwNTMzNDAxMCwxOjEwMTMyNDA0MCwyOjEwNjMyNDAxMCwyOjEwMTM0MTAyMCwzOjEwMTMxNDAyMCwxOjEwMDMxNDA3MCwzOjEwNDMyMTA0MCwyOjEwNjM0MTAyMCwzOjEwMTMzNDAyMA',
	'MiwzOjEwMTAyNDAxMCwzOjEwMDMxNDAxMCwyOjEwMTAyNDA0MCwzOjEwNTAyNDAxMCwzOjEwNjMxMTAzMCwzOjEwMDMxNDAyMCwzOjEwMDMxNDA0MCwzOjEwNTMzNDAxMCwzOjEwMTMyNDA0MCwzOjEwNjMyNDAxMCwzOjEwMTMxNDAyMCwyOjEwNjM0MTAyMCwzOjEwMDMyMTAxMCwzOjEwMTMzNDAyMA',
	'MiwzOjEwMTAyNDAxMCwzOjEwMDMxNDAxMCwxOjEwMTMyNDAzMCwyOjEwNjMxMTAzMCwzOjEwMDMxNDAyMCwzOjEwMDMxNDA0MCwzOjEwMTMxNDAxMCwzOjEwNTMzNDAxMCwzOjEwNjMzNDAxMCwxOjEwMTMyNDA0MCwzOjEwNjMyNDAxMCwzOjEwMTMxNDAyMCwyOjEwMDMxNDA3MCwzOjEwNDMyMTA0MCwxOjEwNjM0MTAyMCwzOjEwMTMzNDAyMA',
	'MiwzOjEwMTAyNDAxMCwzOjEwMDMxNDAxMCwxOjEwMTMyNDAzMCwzOjEwNjMxMTAzMCwzOjEwMDMxNDAyMCwyOjEwMDMxNDAzMCwxOjEwMDMxNDA0MCwzOjEwMTMxNDAxMCwzOjEwNTMzNDAxMCwyOjEwMTMyNDA0MCwzOjEwNjMyNDAxMCwzOjEwMTMxNDAyMCwzOjEwMDMxNDA3MCwzOjEwNDMyMTA0MCwxOjEwNjM0MTAyMCwzOjEwMTMzNDAyMA',
	'MiwzOjEwMTAyNDAxMCwzOjEwMDMxNDAxMCwxOjEwMTMyNDAzMCwxOjEwNjMxMTAzMCwzOjEwMDMxNDAyMCwzOjEwMDMxNDAzMCwyOjEwMDMxNDA0MCwzOjEwMTMxNDAxMCwzOjEwNTMzNDAxMCwyOjEwMTMyNDA0MCwzOjEwNjMyNDAxMCwzOjEwMTMxNDAyMCwzOjEwMDMxNDA3MCwzOjEwNDMyMTA0MCwxOjEwNjM0MTAyMCwzOjEwMTMzNDAyMA',
	'MiwxOjEwMTAyNDAxMCwzOjEwMDMxNDAxMCwyOjEwMTMyNDAzMCwzOjEwNjMxMTAzMCwzOjEwMDMxNDAyMCwzOjEwMDMxNDA0MCwzOjEwMTMxNDAxMCwzOjEwNTMzNDAxMCwyOjEwNjMzNDAxMCwyOjEwMTMyNDA0MCwzOjEwNjMyNDAxMCwzOjEwMTMxNDAyMCwyOjEwMDMxNDA3MCwzOjEwNDMyMTA0MCwxOjEwNjM0MTAyMCwzOjEwMTMzNDAyMA',
	'MiwzOjEwMTAyNDAxMCwzOjEwMDMxNDAxMCwzOjEwNjMxMTAzMCwzOjEwMDMxNDAyMCwyOjEwMDMxNDAzMCwzOjEwMDMxNDA0MCwzOjEwMTMxNDAxMCwyOjEwNTMzNDAxMCwyOjEwMTMyNDA0MCwzOjEwNjMyNDAxMCwzOjEwMTMxNDAyMCwyOjEwMDMxNDA3MCwzOjEwNDMyMTA0MCwyOjEwNjM0MTAyMCwzOjEwMTMzNDAyMA',
	'MiwzOjEwMTAyNDAxMCwzOjEwMDMxNDAxMCwxOjEwMTMyNDAzMCwxOjEwNjMxMTAzMCwzOjEwMDMxNDAyMCwzOjEwMDMxNDAzMCwxOjEwMDMxNDA0MCwzOjEwMTMxNDAxMCwzOjEwNTMzNDAxMCwzOjEwNjMzNDAxMCwzOjEwNjMyNDAxMCwzOjEwMTMxNDAyMCwzOjEwMDMxNDA3MCwzOjEwNDMyMTA0MCwxOjEwNjM0MTAyMCwzOjEwMTMzNDAyMA',
	'MiwzOjEwMTAyNDAxMCwzOjEwMDMxNDAxMCwzOjEwNjMxMTAzMCwzOjEwMDMxNDAyMCwyOjEwMDMxNDAzMCwyOjEwMDMxNDA0MCwzOjEwMTMxNDAxMCwzOjEwNTMzNDAxMCwyOjEwMTMyNDA0MCwzOjEwNjMyNDAxMCwzOjEwMTMxNDAyMCwzOjEwMDMxNDA3MCwzOjEwNDMyMTA0MCwxOjEwNjM0MTAyMCwzOjEwMTMzNDAyMA',
	'MiwzOjEwMTAyNDAxMCwzOjEwMDMxNDAxMCwxOjEwMTMyNDAzMCwzOjEwNjMxMTAzMCwzOjEwMDMxNDAyMCwyOjEwMDMxNDAzMCwzOjEwMDMxNDA0MCwzOjEwMTMxNDAxMCwyOjEwNTMzNDAxMCwxOjEwMTMyNDA0MCwzOjEwNjMyNDAxMCwzOjEwMTMxNDAyMCwyOjEwMDMxNDA3MCwzOjEwNDMyMTA0MCwyOjEwNjM0MTAyMCwzOjEwMTMzNDAyMA'
	])
	
	da.showAggregatedList
end