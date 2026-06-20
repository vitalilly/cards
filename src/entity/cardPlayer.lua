local Entity = require 'core.entity'

local cardPlayer = Entity:extend() --Player object that has this weird name because a player.lua already exists

function cardPlayer:init(o) --Intitialise an instance of the card class
    Entity.init(self,o)
    o = o or {} --Give a blank table if no object is given

    self.health = o.health or 10
    self.deck = o.deck or {}
    self.hand = o.hand or {}

    self.strength = o.strength or 0 --Added onto all damage this player does
    self.pendingDamage = o.pendingDamage or 0 --Damage that will be dealt to the player
    self.allSourcesOfDamage = o.allSourcesOfDamage or {} --Table that will store all opponents damage against this player. We will then take the largest value in this table as the pending damage
    self.currentBlock = o.currentBlock or 0 --Damage that will be prevented 
    self.effectsSOT = o.effectsSOT or {} --All start of turn effects stored as a table
    self.effectsEOT = o.effectsEOT or {} --All end of turn effects stored as a table
    self.minions = o.minions or {} --List of all minions the player has
end

function cardPlayer:DeterminePendingDamage() --Determine the largest source of damage and turn that into the pending damage
    local max = 0
    for i, v in ipairs(self.allSourcesOfDamage) do
        if v > max then
            max = v
        end    
    end
    self.pendingDamage = max

end

function cardPlayer:ResolveDamage() --Determine if the player blocked or not
    local unblockedDamage = self.pendingDamage - self.currentBlock
    self.currentBlock = 0 --Reset these values
    self.pendingDamage = 0

    if unblockedDamage > 0 then --Prevents the player from gaining health from blocking
        self.health = self.health - unblockedDamage
        --TODO add a check for a lose state.
    end
    --TODO Add some kinda else statement to trigger an animation that displays that all damage was blocked

end

return cardPlayer
