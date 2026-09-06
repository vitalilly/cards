-- main.lua
require 'extensions'

local gamestate = require 'lib.gamestate'

require 'core.pushmanager' -- push & shader management
uimanager = require 'core.uimanager' --ui manager using helium
require 'core.soundmanager'
assetmanager = require 'core.assetmanager'
require 'sounds'
local Signal = require 'lib.signal'
math.randomseed(os.time())

local cardGame = require('scenes/menu')
local cardGameScene = cardGame:buildCardGame(4)

local galleryScene = require('scenes/galleryScene')

function love.load()
--    uimanager.loadScene('menu') --test: load "menu" scene (small rectangle)
    gamestate.registerEvents()
    RegisterSignals()

    Signal.emit('SwitchToGame')
end

function RegisterSignals()

    Signal.register('SwitchToGame', function()
        gamestate.switch(cardGameScene)
    end)
    Signal.register('SwitchToGallery', function(cards)
        local gallerySceneInstance = galleryScene:buildGallery(cards)
        gamestate.switch(gallerySceneInstance)
    end)

end
