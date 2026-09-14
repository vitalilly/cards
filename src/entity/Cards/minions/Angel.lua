local minion = require 'entity.minion'

local angel = minion:extend()

function angel:init(o)
    minion.init(self,o)
    o = o or {}


    self.title = "Summon Angel"
    self.targets = false
    self.tag = self.tagList.Minion
    self.health = 2

    self.effectTags = {}
    table.insert(self.effectTags,self.effectTagList.effect)
end

function angel:play()
    self:minionPlay()
end

function angel:effect(tuple) --Additional block from block cards
    local card = tuple.Card
    if card.tag == self.tagList.Defend then
        self.player.currentBlock = self.player.currentBlock + 1 
    end
end

function angel:death()
    self:minionDeath()
end

return angel