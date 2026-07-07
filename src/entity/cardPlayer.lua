local Entity = require 'core.entity'
local hand = require 'entity.hand'

local cardPlayer = Entity:extend() --Player object that has this weird name because a player.lua already exists

function cardPlayer:init(o) --Intitialise an instance of the card class
    Entity.init(self,o)
    o = o or {} --Give a blank table if no object is given

    self.health = o.health or 10
    self.deck = o.deck or {}
    self.hand = o.hand or hand:new()

    self.strength = o.strength or 0 --Added onto all damage this player does
    self.pendingDamage = o.pendingDamage or 0 --Damage that will be dealt to the player
    self.allSourcesOfDamage = o.allSourcesOfDamage or {} --Table that will store all opponents damage against this player. We will then take the largest value in this table as the pending damage
    self.currentBlock = o.currentBlock or 0 --Damage that will be prevented 
    self.effectsSOT = o.effectsSOT or {} --All start of turn effects stored as a table
    self.effectsEOT = o.effectsEOT or {} --All end of turn effects stored as a table
    self.minions = o.minions or {} --List of all minions the player has
    self.opponents = o.opponents or {} --list of all other players
    self.cardQueue = o.cardQueue or {} --Lists all the cards that will play once the player has confirmed their turn
    self.effects = o.effects or {} --Table listing all effects. Effects will respond to specific tags from other cards
    self.cardsPlayed = o.cardsPlayed or 0 --count how many cards played on a given turn
    self.maxCardsPlayed = o.maxCardsPlayed or 1 --max num allowed
end

function cardPlayer:playCard(card,target) --Adds a tuple containing the card played and its target to the cardQueue. nil values for target are handled when target doesnt apply
    local tuple = {Card = card,Target = target}
    table.insert(self.cardQueue,tuple)
end

function cardPlayer:checkForEffects(tuple)
    for i,v in ipairs(self.effects) do
        v.effect(tuple)
    end
end

function cardPlayer:checkForSOT()
    for i,v in ipairs(self.effectsSOT) do
        v.SOT()
    end
end

function cardPlayer:checkForEOT()
    for i,v in ipairs(self.effectsEOT) do
        v.EOT()
    end
end


function cardPlayer:executeCards() --Plays all the cards on the queue
    for i, v in ipairs(self.cardQueue) do
        if v.Target == nil then
            v.Card.play()
        else
            v.Card.playTarget(v.Target)
        end
        self:checkForEffects(v)
    end
    self.cardQueue = {} --Reset the queue
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

function cardPlayer:resetPendingDamage()
    for i, v in ipairs(self.opponents) do --For every opponent we are going to set their associated key value pair to 0
        self.allSourcesOfDamage[v] = 0
    end
end

function cardPlayer:ResolveDamage() --Determine if the player blocked or not
    local unblockedDamage = self.pendingDamage - self.currentBlock
    self.currentBlock = 0 --Reset these values
    self.pendingDamage = 0

    if unblockedDamage > 0 then --Prevents the player from gaining health from blocking
        unblockedDamage = self.MinionsTakeTheHit(unblockedDamage) --Minions take damage first. Update unlbocked damage after minions fall in the line of duty
        self.health = self.health - unblockedDamage
        --TODO add a check for a lose state.
    end
    --TODO Add some kinda else statement to trigger an animation that displays that all damage was blocked

end

function cardPlayer:MinionsTakeTheHit(damage)
    for i, minion in ipairs(self.minions) do
        damage = minion.TakeTheHit(damage)
        if damage == 0 then --We know that all the damage has been dealt out
            break
        end
    end

    return damage --So we know how much damage there is still to block
end

function cardPlayer:draw()
    self.hand:draw()
end
function cardPlayer:update(dt)
    self.hand:update(dt)
end

return cardPlayer
