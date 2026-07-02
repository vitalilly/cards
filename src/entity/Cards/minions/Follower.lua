local minion = require 'entity.minion'

local follower = minion:extend()

function follower:init(o)
    minion.init(self,o)
    o = o or {}


    self.title = "Summon Follower"
    self.targets = false
    self.tag = self.tagList.Minion
    self.health = 1
end

function follower:play()
    table.insert(self.player.minions,self)
    table.insert(self.player.effectsSOT,self)
end

function follower:SOT()
    self.player.maxCardsPlayed = self.player.maxCardsPlayed + 1 --TODO maxcards played should always be set down to its appropriate level at the start of each turn
end

function follower:death()
    self:removeFrom(self.player.minions)
    self:removeFrom(self.player.effectsSOT)
end