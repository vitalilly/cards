local slash = require 'entity.Cards.attacks.Slash'
local fortify = require 'entity.Cards.skills.Fortify'
local bloodFrenzy = require 'entity.Cards.attacks.BloodFrenzy'
local angel = require 'entity.Cards.minions.Angel'
local crusader = require 'entity.Cards.minions.Crusader'
local follower = require 'entity.Cards.minions.Follower'
local monastery = require 'entity.Cards.minions.Monastery'
local bloodKnowledge = require 'entity.Cards.modifiers.BloodKnowledge'
local protectorOfTheFaith = require 'entity.Cards.modifiers.ProtectorOfFaith'

local cardbinder = {
    cards = {
        ["Slash"] = slash,
        ["Fortify"] = fortify,
        ["BloodFrenzy"] = bloodFrenzy,
        ["Angel"] = angel,
        ["Crusader"] = crusader,
        ["Follower"] = follower,
        ["Monastery"] = monastery,
        ["BloodKnowledge"] = bloodKnowledge,
        ["ProtectorOfTheFaith"] = protectorOfTheFaith
    }
}

function cardbinder:getCard(cardName,owner)
    return self.cards[cardName]:new({player = owner})
end

return cardbinder

