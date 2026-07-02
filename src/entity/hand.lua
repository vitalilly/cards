local Entity = require 'core.entity'

local hand = Entity:extend()

function hand:init(o) --Intitialise an instance of the card class
    Entity.init(self,o)
    o = o or {} --Give a blank table if no object is given

    self.cards = o.cards or {}
    self.deck = o.deck or {} --Set the deck that is associated with this hand
end

function hand:drawCards(x) --Draw x cards from the deck
    for i = 1,x,1 do
        local card = self.deck:drawACard()
        table.insert(self.cards,card)
    end
end

function hand:discardHand() --Put the entire hand into the discard pile
    for i, v in ipairs(self.cards) do
        self.deck.discard(v)
    end
    self.cards = {}
end

--TODO. Add functionality to select and then play cards

return hand