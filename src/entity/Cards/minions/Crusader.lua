local minion = require 'entity.minion'

local crusader = minion:extend()

function crusader:init(o)
    minion.init(self,o)
    o = o or {}


    self.title = "Summon Crusader"
    self.targets = false
    self.tag = self.tagList.Minion
    self.health = 2
    
    self.effectTags = {}
    table.insert(self.effectTags,self.effectTagList.effect)
end

function crusader:play()
    self:minionPlay()
end

function crusader:effect(tuple) --Additional attack
    local card = tuple.Card
    local target = tuple.Target
    if card.tag == self.tagList.Attack then
        self:damage(target,1) --Deal 1 damage to the target of the attack
    end
end

function crusader:death()
    self:minionDeath()
end

return crusader