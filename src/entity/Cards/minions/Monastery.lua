local minion = require 'entity.minion'

local monastery = minion:extend()

function monastery:init(o)
    minion.init(self,o)
    o = o or {}

    self.targets = false
    self.tag = self.tagList.Minion
    self.health = 2
end

function monastery:play()
    table.insert(self.player.minions,self)
    table.insert(self.player.effectsSOT,self)
end

function monastery:SOT()
    self.player.hand.drawCards(1)
end

function monastery:death()
    self:removeFrom(self.player.minions)
    self:removeFrom(self.player.effectsSOT)
end