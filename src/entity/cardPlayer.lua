local Entity = require 'core.entity'
local hand = require 'entity.hand'
local deck = require 'entity.deck'
local cardbinder = require 'core.cardbinder'
local deckTemplate = require 'core.deckTemplate'
local globals = require 'globals'
local assetManager = require 'core.assetmanager'
local conf = require 'conf'
local label = require 'entity.label'
local Signal = require 'lib.signal'

local cardPlayer = Entity:extend() --Player object that has this weird name because a player.lua already exists

local cardsToDraw = 10 --Global that governs how many cards players draw each turn

function cardPlayer:init(o) --Intitialise an instance of the card class
    o = o or {} --Give a blank table if no object is given
    Entity.init(self,o)

    self.ID = o.ID or -1
    self.turnManager = o.turnManager or {}
    self.playOver = o.playOver or false

    self.maxHealth = o.maxHealth or 10
    self.health = self.maxHealth

    self.deck = o.deck or deck:new()
    self.deck = deckTemplate:Balanced(self) --For testing
    self.hand = o.hand or hand:new({player = self, deck = self.deck})

    self.pendingDamage = o.pendingDamage or 0 --Damage that will be dealt to the player
    self.allSourcesOfDamage = o.allSourcesOfDamage or {} --Table that will store all opponents damage against this player. We will then take the largest value in this table as the pending damage
    self.currentBlock = 0 --Damage that will be prevented 
    self.effectsSOT = o.effectsSOT or {} --All start of turn effects stored as a table
    self.effectsEOT = o.effectsEOT or {} --All end of turn effects stored as a table
    self.minions = o.minions or {} --List of all minions the player has

    self.opponents = o.opponents or {} --list of all other players
    self.selectedOpponent = o.selectedOpponent or 1 --The index of the player thats being targeted and rendered

    self.cardQueue = {} --Lists all the cards that will play once the player has confirmed their turn
    self.effects = o.effects or {} --Table listing all effects. Effects will respond to specific tags from other cards
    self.cardsPlayed = o.cardsPlayed or 0 --count how many cards played on a given turn
    self.maxCardsPlayed = o.maxCardsPlayed or 10 --max num allowed. Set to 10 for testing

    self.sprite = o.sprite or assetManager.players["Player1"]

    self.healthLabel = label:new({text = "H " .. self.health .. "/" .. self.maxHealth, x = 0, y = conf.windowh-30})
    self.defenseLabel = label:new({text = "D " .. self.currentBlock, x = conf.windoww/2 - 50, y = 30})
    self.pendingLabel = label:new({text = "P ".. self.pendingDamage,x = conf.windoww/2 + 50, y = 30})

    if self.ID ~= globals.ID then --All beyond here go no further unless you are the truest of players
        self.healthLabel:setXY(conf.windoww/2 - 50,conf.windowh/2 - 140)
        self.defenseLabel:setXY(conf.windoww/2-70,conf.windowh/2 + 110)
        self.pendingLabel:setXY(conf.windoww/2+30,conf.windowh/2 + 110)
        return
    end

    self.buttons = {["endTurn"] = self:makeEndTurn(),
    ["rightRotate"] = self:makeRightRotate(),
    ["leftRotate"] = self:makeLeftRotate(),
    ["showDiscard"] = self:makeShowDiscard(),
    ["showDeck"] = self:makeShowDeck(),
    ["ownMinions"] = self:makeOwnMinions(),
    ["theirMinions"] = self:makeTheirMinions()}

    self:drawButtons()
    Signal.register("drawPlayerButtons", function() self:drawButtons() end)
end

function cardPlayer:submitTurn() --Called by the End Turn Button
    self.turnManager:submitTurn(self.ID,self.cardQueue)
end

function cardPlayer:makeEndTurn()
    local localX,localY = 400,400
    local localW,localH = 120,30

    localW,localH = push:toGame(localW,localH)
    localX,localY = push:toGame(localX,localY)
    local view = {h = localH, w = localW,x = localX, y = localY}

    local endTurnButton = endTurn(self,view.w,view.h)
    endTurnButton:draw(view.x,view.y)
    endTurnButton.view = view
    return endTurnButton
end

function cardPlayer:makeRightRotate()
    local localW,localH = 16,30
    local localX,localY = conf.windoww - (localW * 2),conf.windowh/2 - localH

    --localW,localH = push:toGame(localW,localH)
    --localX,localY = push:toGame(localX,localY)
    local view = {h = localH, w = localW,x = localX, y = localY}

    local rightRotateButton = cycleRight(self)
    rightRotateButton:draw(view.x,view.y)
    rightRotateButton.view = view
    return rightRotateButton
end

function cardPlayer:makeLeftRotate()
    local localW,localH = 16,30
    local localX,localY = localW*2,conf.windowh/2 - localH

    --localW,localH = push:toGame(localW,localH)
    --localX,localY = push:toGame(localX,localY)
    local view = {h = localH, w = localW,x = localX, y = localY}

    local leftRotateButton = cycleLeft(self)
    leftRotateButton:draw(view.x,view.y)
    leftRotateButton.view = view
    return leftRotateButton
end

function cardPlayer:makeShowDiscard()
    local localX,localY = conf.gamew - 40,conf.gameh-50
    local localW,localH = 200,30

    localX,localY = push:toGame(localX,localY)
    localW,localH = push:toGame(localW,localH)
    local view = {h = localH, w = localW,x = localX, y = localY}

    local showDiscardButton = showDiscard(self,view.w,view.h)
    showDiscardButton:draw(view.x,view.y)
    showDiscardButton.view = view
    return showDiscardButton
end

function cardPlayer:makeShowDeck()
    local localX,localY = 40,conf.gameh-50
    local localW,localH = 200,30

    localX,localY = push:toGame(localX,localY)
    localW,localH = push:toGame(localW,localH)
    local view = {h = localH, w = localW,x = localX, y = localY}

    local showDeckButton = showDeck(self,view.w,view.h)
    showDeckButton:draw(view.x,view.y)
    showDeckButton.view = view
    return showDeckButton
end

function cardPlayer:makeOwnMinions()
    local localX,localY = conf.gamew + 50,conf.gameh-50
    local localW,localH = 200,30

    --localX,localY = push:toGame(localX,localY)
    localW,localH = push:toGame(localW,localH)

    local view = {h = localH, w = localW,x = localX, y = localY}

    local ownMinionsButton = ownMinions(self,view.w,view.h)
    ownMinionsButton:draw(view.x,view.y)
    ownMinionsButton.view = view
    return ownMinionsButton
end

function cardPlayer:makeTheirMinions()
    local localX,localY = conf.gamew + 50,conf.gameh - 20
    local localW,localH = 200,30

    --localX,localY = push:toGame(localX,localY)
    localW,localH = push:toGame(localW,localH)

    local view = {h = localH, w = localW,x = localX, y = localY}

    local theirMinionsButton = theirMinions(self,view.w,view.h)
    theirMinionsButton:draw(view.x,view.y)
    theirMinionsButton.view = view
    return theirMinionsButton
end


function cardPlayer:RotateTarget(left) -- Called by the right arrow button
    if left then
        self.selectedOpponent = self.selectedOpponent - 1
        if self.selectedOpponent <= 0 then
            self.selectedOpponent = #self.opponents
        end
    else
        self.selectedOpponent = self.selectedOpponent + 1
        if self.selectedOpponent > #self.opponents then
            self.selectedOpponent = 1
        end
    end
end

function cardPlayer:startTurn()
    self:checkForSOT()
end

function cardPlayer:startPlay() --Draw cards for turn
    self.hand:drawCards(cardsToDraw)
end

function cardPlayer:endTurn()
    --CLEAN UP
    self:checkForEOT()
    self.hand:discardHand()
    self.turnOver = false
    self.cardQueue = {} --Reset the queue
    self.cardsPlayed = 0
    --DAMAGE STEP
    self:ResolveDamage()--First now any pending damage will be taken
    self:DeterminePendingDamage()--Determine what the new Pending Damage instance
    self:resetSourcesOfDamage()--Reset sources of damage
end

function cardPlayer:playCard(card) --Adds a tuple containing the card played and its target to the cardQueue. nil values for target are handled when target doesnt apply. Returns if the card was played or not

    if self.cardsPlayed >= self.maxCardsPlayed then --Check to see if the player can even play anymore cards
        return false
    end

    self.cardsPlayed = self.cardsPlayed + 1

    local target
    if card.targets then
        target = self:getCurrentOpponent() --Players will be able to switch between all the players in their view with an arrow or smth. The player who is currently in view will be targetted.
        print(target.ID .. " Was just targeted against")
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
        v:effect(tuple)
    end
end

function cardPlayer:checkForSOT()
    for _,v in ipairs(self.effectsSOT) do
        v:SOT()
    end
end

function cardPlayer:checkForEOT()
    for _,v in ipairs(self.effectsEOT) do
        v:EOT()
    end
end

function cardPlayer:DeterminePendingDamage() --Determine the largest source of damage and turn that into the pending damage
    local max = 0
    for _, v in pairs(self.allSourcesOfDamage) do

        if v > max then
            max = v
        end
    end
    self.pendingDamage = max
end

function cardPlayer:resetSourcesOfDamage()
    for _, v in pairs(self.opponents) do --For every opponent we are going to set their associated key value pair to 0
        self.allSourcesOfDamage[v] = 0
    end
end

function cardPlayer:ResolveDamage() --Determine if the player blocked or not
    local unblockedDamage = self.pendingDamage - self.currentBlock

    self.currentBlock = 0 --Reset these values
    self.pendingDamage = 0

    if unblockedDamage > 0 then --Prevents the player from gaining health from blocking
        unblockedDamage = self:MinionsTakeTheHit(unblockedDamage) --Minions take damage first. Update unlbocked damage after minions fall in the line of duty
        self.health = self.health - unblockedDamage
        --TODO add a check for a lose state.
    end
    --TODO Add some kinda else statement to trigger an animation that displays that all damage was blocked

end

function cardPlayer:MinionsTakeTheHit(damage)
    for _, minion in ipairs(self.minions) do
        damage = minion:TakeTheHit(damage)
        if damage == 0 then --We know that all the damage has been dealt out
            break
        end
    end

    return damage --So we know how much damage there is still to block
end

function cardPlayer:getCurrentOpponent()
    if #self.opponents == 0 then
        return nil
    end
    return self.opponents[self.selectedOpponent]
end

function cardPlayer:draw()
    self.hand:draw()
    self:drawOwnLabels()
    local opponent = self:getCurrentOpponent()
    if opponent ~= nil then
        opponent:drawSelf()
    end

end

function cardPlayer:drawOwnLabels()
    self.healthLabel.text = "H " .. self.health .. "/" .. self.maxHealth
    self.healthLabel:draw()

    self.defenseLabel.text = "D " .. self.currentBlock
    self.defenseLabel:draw()
    
    self.pendingLabel.text = "P ".. self.pendingDamage
    self.pendingLabel:draw()

end

function cardPlayer:drawSelf()
    local localX,localY = push:toGame(conf.windoww/2 - 45,conf.windowh/2 - 100)
    love.graphics.draw(self.sprite,localX,localY)

    self:drawOwnLabels()
end

function cardPlayer:update(dt)
    self.hand:update(dt)
end

function cardPlayer:undrawButtons()
    for _,v in pairs(self.buttons) do
        v:undraw()
    end
end

function cardPlayer:drawButtons()
    for _,v in pairs(self.buttons) do
        v:draw(v.view.x,v.view.y)
    end
end

return cardPlayer
