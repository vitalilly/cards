local minion = require 'entity.minion'

local crusader = minion:extend()

function crusader:init(o)
    minion.init(self,o)
    o = o or {}


    self.title = "Summon Crusader"
    self.targets = false
    self.tag = self.tagList.Defend
    self.health = 2
end

function crusader:play()
    table.insert(self.player.minions,self)
    table.insert(self.player.effects,self)
end

function crusader:effect(tuple) --Additional block from block cards
    local card = tuple.Card
    local target = tuple.Target
    if card.tag == self.tagList.Attack then
        self:damage(target,1) --Deal 1 damage to the target of the attack
    end
end

function crusader:death()
    self:removeFrom(self.player.minions)
    self:removeFrom(self.player.effects)
end

return crusader