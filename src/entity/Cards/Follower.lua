local minion = require 'entity.minion'

local follower = minion:extend()

function follower:init(o)
    minion.init(self,o)
    o = o or {}

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
    self.player.minions[self] = nil
    self.player.effectsSOT[self] = nil
end