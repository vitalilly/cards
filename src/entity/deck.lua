local Entity = require 'core.entity'

local deck = Entity:extend()

function deck:init(o) --Intitialise an instance of the card class
    o = o or {} --Give a blank table if no object is given
    Entity.init(self,o)

    self.trueCards = o.trueCards or {} --Stores what the players deck looks like regardless of the current game state
    self.cards = o.cards or {}
    self.discardPile = o.discardPile or {}
end

function deck:addCard(card)
    table.insert(self.cards,card)
    table.insert(self.trueCards,card)
end

function deck:discard(card)
    table.insert(self.discardPile,card)
end

function deck:drawACard() --return the card at the end of the cards array and remove it
    if #self.cards == 0 then --Check to see if the deck is empty or not.
        self:shuffleInDiscard() --Is this correct?!
    end
    local card = self.cards[#self.cards] --Access the index equal to the number of elements in the array. Lua starts at index 1 lmao
    table.remove(self.cards, #self.cards)
    return card
end

function deck:shuffleInDiscard() --Shuffle in discard pile
    if #self.discardPile == 0 then
        print("Placeholder logic for losing the game?")
    end
    self.cards = self.discardPile --Swap the discard pile with the empty cards array
    self:shuffle() --Shuffle the deck
end

function deck:shuffle()
    local shuffledCards = {}
    local size = #self.cards
    for i = 1,size,1 do --For every card in the deck
        local randomValue = math.random(1,#self.cards) --Get a random value in the array
        local card = table.remove(self.cards,randomValue) --remove it from the array so we dont encounter it again and get the removed entry
        table.insert(shuffledCards,card) --add it to the new array
    end
    self.cards = shuffledCards --Update the cards array
end

return deck
