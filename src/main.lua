-- main.lua
require 'extensions'

local gamestate = require 'lib.gamestate'

--helium (ui) implementation
helium = require 'helium'
scene = helium.scene.new(true)
scene:activate()

elementCreator = helium(function(param,view)
    return function()
        love.graphics.setColor(0.3,0.3,0.3)
        love.graphics.rectangle('fill',0,0,view.w,view.h)
        love.graphics.setColor(1,1,1)
        love.graphics.print(param.text)
    end
end)

--other stuff
require 'core.soundmanager'
require 'sounds'
math.randomseed(os.time())


function love.load()
    gamestate.registerEvents()
    gamestate.switch(require('scenes/menu'):build())
end
