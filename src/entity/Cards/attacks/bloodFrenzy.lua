local card = require 'entity.card'

local bloodFrenzy = card:extend()

function bloodFrenzy:init(o)
    card.init(self,o)
    o = o or {}

    self.title = "Blood Frenzy"
    self.targets = true
    self.tag = self.tagList.Attack
end

function bloodFrenzy:playTarget(target) --Deal 2 damage to target player
    self:damage(2,target)
    table.insert(self.player.effectsEOT,self)
    table.insert(self.player.effects,self)
end

function bloodFrenzy:effect(tuple) --Additional damage from attack cards
    local card = tuple.Card
    local target = tuple.Target
    if card.tag == self.tagList.Attack then
        self:damage(target,2) --Deal 2 damage to the target of the attack
    end
end

function bloodFrenzy:EOT()
    self:removeFrom(self.player.effects)
    self:removeFrom(self.player.effectsEOT)
end

return bloodFrenzy