local card = require 'entity.card'

local BloodKnowledge = card:extend()

function BloodKnowledge:init(o)
    card.init(self,o)
    o = o or {}
    
    self.title = "Blood Knowledge"
    self.targets = false
    self.tag = self.tagList.Modifier
    self.playersAttacked = {}
end

function BloodKnowledge:play()
    table.insert(self.player.effects,self)
    table.insert(self.player.effectsSOT,self)
end

function BloodKnowledge:effect(tuple) --Add to a list of players attacked
    local card = tuple.Card
    local target = tuple.Target
    if card.tag ~= self.tagList.Attack then
        return--Not an attack dont consider it
    end

    for i, v in ipairs(self.playersAttacked) do
        if target == v then
            return --This target was already attacked so dont consider it
        end
    end
    table.insert(self.playersAttacked,target) --Add this target to the list
end

function BloodKnowledge:SOT() --For each player attacked at the start of the next turn draw that many cards.
    self.player.hand.drawCards(#self.playersAttacked)
    self.playersAttacked = {} --Reset the list
end