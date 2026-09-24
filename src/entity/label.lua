local Entity = require 'core.entity'

local label = Entity:extend()

function label:init(o)
    o = o or {}
    Entity.init(self,o)

    self.text = o.text or ""
    self.x = o.x or 0
    self.y = o.y or 0

    self:setXY(self.x,self.y)
end

function label:setXY(x,y)
    self.x,self.y = push:toGame(x,y)
end

function label:draw()
    self:drawAt(self.x,self.y)
end

function label:drawAt(x,y)
    love.graphics.push()
    love.graphics.translate(x,y)
    love.graphics.print(self.text,0,0)
    love.graphics.pop()
end

return label