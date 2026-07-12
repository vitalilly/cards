-- main.lua
require 'extensions'

local gamestate = require 'lib.gamestate'

require 'core.pushmanager' -- push & shader management
uimanager = require 'core.uimanager' --ui manager using helium
require 'core.soundmanager'
require 'sounds'
math.randomseed(os.time())

local cardGame = require('scenes/menu')

function love.load()
    uimanager.loadScene('menu') --test: load "menu" scene (small rectangle)
    gamestate.registerEvents()
    gamestate.switch(cardGame:buildCardGame(1))

end
