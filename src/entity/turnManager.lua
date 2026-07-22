local Entity = require 'core.entity'
local cardPlayer = require 'entity.cardPlayer'
local globals = require 'globals'
local assetManager = require 'core.assetmanager'

local turnManager = Entity:extend()

function turnManager:init(o)
    o = o or {}
    Entity.init(self,o)
   
    self.numPlayers = o.numPlayers or 4
    self.players = self:makePlayers()
    self.cardQueue = {}

    self:startPhase()
end

function turnManager:makePlayers()
    local output = {}
    for i= 1,self.numPlayers do
        local player = cardPlayer:new({ID = i, turnManager = self,sprite = assetManager["Player" .. i]})
        table.insert(output,player)
    end
    output = self:populateOpponents(output)
    return output
end

function turnManager:populateOpponents(playerList) --Assuming every other player is your enemy
    for i,v in ipairs(playerList) do
        v.opponents = v.opponents or {}
        for j,w in ipairs(playerList) do
            if i ~= j then
                table.insert(v.opponents,w) --Insert the other player into their opponents array
                v.allSourcesOfDamage[w] = 0 --Initialise the source of damage with the key value pair of each opponent
            end
        end
    end
    return playerList
end

function turnManager:startPhase()
    for _,v in ipairs(self.players) do
        v:startTurn()
        v.playOver = self:makePlayersPass(v,1)
    end
    self:playPhase()
end

function turnManager:makePlayersPass(player,ID) --Make all players that are not the ID pass their turn. USED FOR TESTING
    return player.ID ~= ID
end

function turnManager:playPhase()
    for _,v in ipairs(self.players) do
        v:startPlay()
    end
end

function turnManager:submitTurn(ID,cardsPlayed)
    print("The button works")
    if self.players[ID].playOver then
        return
    end
    self.players[ID].playOver = true
    self.cardQueue[ID] = cardsPlayed

    for _,v in ipairs(self.players) do
        if not v.playOver then
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
                print(v.Target.ID .. " We are trying to target this player")
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