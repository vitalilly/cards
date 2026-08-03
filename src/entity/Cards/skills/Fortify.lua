local card = require 'entity.card'

local fortify = card:extend()
local assetmanager = require 'core.assetmanager'

function fortify:init(o)
    card.init(self,o)
    o = o or {}

    self.title = "Fortify"
    self.targets = true
    self.tag = self.tagList.Defend
    self.image = assetmanager:getCardArt("Fortify")
end

function fortify:playTarget(target) --Block for 3
    self:block(3)
end

return fortify