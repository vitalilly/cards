local Entity = require 'core.entity'
local hand = require 'entity.hand'
local deck = require 'entity.deck'
local slash = require 'entity.Cards.attacks.Slash'
local globals = require 'globals'

local cardPlayer = Entity:extend() --Player object that has this weird name because a player.lua already exists

local cardsToDraw = 5 --Global that governs how many cards players draw each turn

function cardPlayer:init(o) --Intitialise an instance of the card class
    o = o or {} --Give a blank table if no object is given
    Entity.init(self,o)

    self.ID = o.ID or -1
    self.turnManager = o.turnManager or {}
    self.playOver = o.playOver or false

    self.health = o.health or 10
    self.deck = o.deck or deck:new()
    self.deck = cardPlayer:testHand(20) --For testing
    self.hand = o.hand or hand:new({player = self, deck = self.deck})

    self.pendingDamage = o.pendingDamage or 0 --Damage that will be dealt to the player
    self.allSourcesOfDamage = o.allSourcesOfDamage or {} --Table that will store all opponents damage against this player. We will then take the largest value in this table as the pending damage
    self.currentBlock = o.currentBlock or 0 --Damage that will be prevented 
    self.effectsSOT = o.effectsSOT or {} --All start of turn effects stored as a table
    self.effectsEOT = o.effectsEOT or {} --All end of turn effects stored as a table
    self.minions = o.minions or {} --List of all minions the player has

    self.opponents = o.opponents or {} --list of all other players
    self.selectedOpponent = o.selectedOpponent or 1 --The index of the player thats being targeted and rendered

    self.cardQueue = o.cardQueue or {} --Lists all the cards that will play once the player has confirmed their turn
    self.effects = o.effects or {} --Table listing all effects. Effects will respond to specific tags from other cards
    self.cardsPlayed = o.cardsPlayed or 0 --count how many cards played on a given turn
    self.maxCardsPlayed = o.maxCardsPlayed or 10 --max num allowed. Set to 10 for testing

    self.endTurnButton = self:makeEndTurn()
end

function cardPlayer:makeEndTurn()
    if self.ID ~= globals.ID then
        return
    end

    local localX,localY = 400,400
    local localW,localH = 120,30
    localW,localH = push:toGame(localW,localH)
    localX,localY = push:toGame(localX,localY)
    local view = {h = localH, w = localW,x = localX, y = localY}
    local endTurnButton = endTurn(self, view.w, view.h)
    endTurnButton.view = view
    return endTurnButton
end

function cardPlayer:testHand(num) --Test function to see if the hand is working
    local result = deck:new()
    for i = 1,num,1 do
        result:addCard(slash:new({player = self}))
    end
    return result
end

function cardPlayer:startTurn()
    self:checkForSOT()
end

function cardPlayer:startPlay()
    self.hand:drawCards(cardsToDraw)
end

function cardPlayer:endTurn()
    self:checkForEOT()
    self.hand:discardHand()
end

function cardPlayer:playCard(card) --Adds a tuple containing the card played and its target to the cardQueue. nil values for target are handled when target doesnt apply. Returns if the card was played or not

    if self.cardsPlayed >= self.maxCardsPlayed then --Check to see if the player can even play anymore cards
        return false
    end

    self.cardsPlayed = self.cardsPlayed + 1

    local target
    if card.targets then
        target = self.opponents[self.selectedOpponent] --Players will be able to switch between all the players in their view with an arrow or smth. The player who is currently in view will be targetted.
    else
        target = nil
    end

    local tuple = {Card = card,Target = target}
    table.insert(self.cardQueue,tuple)
    return true
end

--TODO Add arrows to the screen that allow the player to cycle through opponents for the purpose of understanding the field and targeting.

function cardPlayer:checkForEffects(tuple)
    for _,v in ipairs(self.effects) do
        v.effect(tuple)
    end
end

function cardPlayer:checkForSOT()
    for _,v in ipairs(self.effectsSOT) do
        v.SOT()
    end
end

function cardPlayer:checkForEOT()
    for _,v in ipairs(self.effectsEOT) do
        v.EOT()
    end
end


function cardPlayer:executeCards() --Plays all the cards on the queue
    
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
    self.endTurnButton:draw(unpack(self.endTurnButton.view))
end
function cardPlayer:update(dt)
    self.hand:update(dt)
end

return cardPlayer
