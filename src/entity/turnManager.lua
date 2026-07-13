local Entity = require 'core.entity'
local cardPlayer = require 'entity.cardPlayer'
local globals = require 'globals'

local turnManager = Entity:extend()

function turnManager:init(o)
    self.numPlayers = o.numPlayers or 2
    self.players = self:makePlayers()
    self.cardQueue = {}

    self:startPhase()
end

function turnManager:makePlayers()
    local output = {}
    for i= 1,self.numPlayers,1 do
        local player = cardPlayer:new({ID = i, turnManager = self})
        output[i] = player
    end
    return output
end

function turnManager:startPhase()
    for _,v in ipairs(self.players) do
        v:startTurn()
    end
    self:playPhase()
end

function turnManager:playPhase()
    for _,v in ipairs(self.players) do
        v:startPlay()
    end
end

function turnManager:submitTurn(ID,cardsPlayed)
    if self.players[ID].playOver then
        return
    end
    self.players[ID].playOver = true
    self.cardQueue[ID] = cardsPlayed

    for _,v in ipairs(self.players) do
        if not self.players[ID].playOver then
            return
        end
    end
    self:executeCards()
    self:endPhase()
end

function turnManager:executeCards()
    for i, aCardQueue in ipairs(self.cardQueue) do
        for _, v in ipairs(aCardQueue) do
            if v.Target == nil then
                v.Card:play()
            else
                v.Card:playTarget(v.Target)
            end
            self.players[i]:checkForEffects(v) --Get the player that this queue is associated with and check out their effects
        end
    end
end

function turnManager:endPhase()
    for _,v in ipairs(self.players) do
        v:endTurn()
    end
    self:startPhase()--and the loop continues
end

function turnManager:draw()
    self.players[globals.ID]:draw()
end

function turnManager:update(dt)
    self.players[globals.ID]:update(dt)
end

--TODO do turn order management.

return turnManager