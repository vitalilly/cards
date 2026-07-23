local lume = require 'lib.lume'
local Entity = require 'core.entity'

local Background = Entity:extend()  
--

local active = false
function Background:init(t)
    Entity.init(self,t)
    t = t or {}
    assert(t.scene, 'scene is required.')
    self.scene = t.scene
    Background:choose(self.scene)
end

function Background:choose(scene)
        image = assetmanager.backgrounds[scene]
        active = true
end

function Background:draw() 
    love.graphics.push()
    love.graphics.translate(0,0)
    if active then 
        love.graphics.draw(image,0,0)
    end
    love.graphics.pop()
end

return Background
