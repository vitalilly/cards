local entity = require 'core.entity'
local hitbox = entity:extend()

function hitbox:init(o)
    entity.init(self,o)
    o = o or {}

    self.x = o.x or 0
    self.y = o.y or 0
    self.width = o.width or 0
    self.height = o.height or 0
end

function hitbox:rectangle(x,y)
    local xHit = x >= self.x and x < self.x + self.width --To the right
    local yHit = y >= self.y and y < self.y + self.height --downwards
    return xHit and yHit
end

return hitbox