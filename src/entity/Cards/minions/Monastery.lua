local minion = require 'entity.minion'

local monastery = minion:extend()

function monastery:init(o)
    minion.init(self,o)
    o = o or {}

    self.targets = false
    self.tag = self.tagList.Minion
    self.health = 2

    self.effectTags = {}
    table.insert(self.effectTags,self.effectTagList.SOT)
end

function monastery:play()
    self:minionPlay()
end

function monastery:SOT()
    self.player.hand.drawCards(1)
end

function monastery:death()
    self:minionDeath()
end

return monastery