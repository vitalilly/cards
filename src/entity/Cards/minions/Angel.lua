local minion = require 'entity.minion'

local angel = minion:extend()

function angel:init(o)
    minion.init(self,o)
    o = o or {}


    self.title = "Summon Angel"
    self.targets = false
    self.tag = self.tagList.Minion
    self.health = 2
end

function angel:play()
    table.insert(self.player.minions,self)
    table.insert(self.player.effects,self)
end

function angel:effect(tuple) --Additional block from block cards
    local card = tuple.Card
    if card.tag == self.tagList.Defend then
        self.player.currentBlock = self.player.currentBlock + 1    
    end
end

function angel:death()
    self:removeFrom(self.player.minions)
    self:removeFrom(self.player.effects)
end

return angel