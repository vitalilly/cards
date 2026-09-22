local class = require 'utils.class'
local deck = require 'entity.deck'
local cardBinder = require 'core.cardbinder'

local deckTemplate = class()

function deckTemplate:init(t)
    t = t or {}
end

function deckTemplate:Balanced(owner)
    local returnDeck = deck:new()

    for i = 1,5 do
        returnDeck:addCard(cardBinder:getCard("Slash",owner))
    end

    for i = 1, 5 do
        returnDeck:addCard(cardBinder:getCard("Fortify",owner))
    end

    for i = 1, 5 do
        returnDeck:addCard(cardBinder:getCard("Angel",owner))
    end

    return returnDeck

end

return deckTemplate