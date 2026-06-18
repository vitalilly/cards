Entity = require 'core.entity'

hand = Entity:extend()

function hand:init(o) --Intitialise an instance of the card class
    Entity.init(self,o)
    o = o or {} --Give a blank table if no object is given

    self.cards = o.cards or {}

end

function hand:drawCards(x, deck) --Draw x cards from the deck
    for i = 1,x,1 do
        local card = deck:drawACard()
        table.insert(self.cards,card)
    end
end

function hand:discardHand(deck) --Put the entire hand into the discard pile
    for i, v in ipairs(self.cards) do
        deck.discard(v)
    end
    self.cards = {}
end

--TODO. Add functionality to select and then play cards

return hand