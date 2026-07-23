local lume = require 'lib.lume'
local Entity = require 'core.entity'

local Background = Entity:extend()  
--

function Background:init(t)
    Entity.init(self,t)
    t = t or {}
    assert(t.scene, 'scene is required.')
    self.scene = t.scene
    Background:choose(self.scene)
end

function Background:choose(scene)
        image = assetmanager.backgrounds[scene]
end

function Background:draw() 
    love.graphics.push()
    love.graphics.translate(0,0)
    love.graphics.draw(image,0,0)
    love.graphics.pop()
end

return Background
