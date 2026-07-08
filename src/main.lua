-- main.lua
require 'extensions'

local gamestate = require 'lib.gamestate'

require 'core.pushmanager' -- push & shader management
uimanager = require 'core.uimanager' --ui manager using helium
require 'core.soundmanager'
require 'sounds'
math.randomseed(os.time())

function love.load()
    uimanager.loadScene('menu') --test: load "menu" scene (small rectangle)
    gamestate.registerEvents()
    gamestate.switch(require('scenes/menu'):build())
end
