local Entity = require 'core.entity'
local cardPlayer = require 'entity.cardPlayer'
local globals = require 'globals'

local turnManager = Entity:extend()

function turnManager:init(o)
    self.numPlayers = o.numPlayers or 2
    self.players = self:makePlayers()
end

function turnManager:makePlayers()
    local output = {}
    for i= 1,self.numPlayers,1 do
        local player = cardPlayer:new({})
        table.insert(output,player)
    end
    return output
end

function turnManager:draw()
    self.players[globals.ID]:draw()
end

function turnManager:update(dt)
    self.players[globals.ID]:update(dt)
end

--TODO do turn order management.

return turnManager