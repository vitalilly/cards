local card = require 'entity.card'

local slash = card:extend()
local assetManager = require 'core.assetmanager'

function slash:init(o)
    card.init(self,o)
    o = o or {}

    self.title = "Slash"
    self.targets = true
    self.image = assetManager:getCardArt("Placeholder")
    self.tag = self.tagList.Attack
end

function slash:playTarget(target) --Deal 4 damage to target player
    self:damage(4,target)
end

return slash
