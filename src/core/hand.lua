hand = { --For the purpose of allowing the player to view and play the cards in their hand
    cards = {}
}

function hand:new(o) --Intitialise an instance of the card class
    o = o or {} --Give a blank table if no object is given
    setmetatable(o,self)
    self.__index = self

    o.cards = o.cards or {}

    return o
end