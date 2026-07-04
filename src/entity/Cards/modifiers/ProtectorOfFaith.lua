local card = require 'entity.card'

local ProtectorOfFaith = card:extend()

function ProtectorOfFaith:init(o)
    card.init(self,o)
    o = o or {}
    
    self.title = "Protector Of The Faith"
    self.targets = false
    self.tag = self.tagList.Modifier
end

function ProtectorOfFaith:play()
    table.insert(self.player.effectsSOT,self)
end

function ProtectorOfFaith:SOT() --Minions gain health
    for i, v in ipairs(self.player.minions) do
        v.health = v.health + 1
    end
end

return ProtectorOfFaith