local card = require 'entity.card'

local slash = card:extend()

function slash:init(o)
    card.init(self,o)
    o = o or {}

    self.targets = true
    self.tag = self.tagList.Attack
end

function slash:playTarget(target) --Deal 4 damage to target player
    self:damage(4,target)
end