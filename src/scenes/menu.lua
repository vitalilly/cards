local gamestate = require 'lib.gamestate'
local lume = require 'lib.lume'
local SceneBuilder = require 'core.scenebuilder'
local Asteroid = require 'entity.asteroid'

local w, h = love.graphics.getDimensions()
local background = assetmanager.backgrounds.menu
local layers = {
bg = 0,
card = 1,
unit = 2,
inf = 999,--debug value
}

local S = SceneBuilder()

function S:addPlayers(num) -- num is the number of players to create in this scene
    S:addObjectAs('turnManager', 
    {script = 'entity.turnManager',
    arguments = {
    numPlayers = num,
    scene = S.scene,
    z = layers.card,
    }
})
end

function S:buildCardGame(num) --Number of players to create
    self:addPlayers(num)
    return self:build()
end

S:addObjectAs('background',require('entity.background'){
    scene = 'menu',
    z = layers.bg,
    })

S:addObjectAs('knight',{
    script = 'entity.player',
    arguments = {
    x=1,y=100,
    scene = S.scene,
    z = layers.unit,
    }
})

S:addGroup('widgets', {z = 1, init = function(group)
    -- play button
    group:addAs('playLabel', require('entity.widgets.Label'){
        x = w/2, y = h/2, text = 'Play'
    })
    group:addAs('playButton', require('entity.widgets.Button'){
        x = w/2,
        y = h/2,
        w = group.objects.playLabel.textObject:getWidth(),
        h = group.objects.playLabel.textObject:getHeight(),
        onClick = function()
            gamestate.switch(require('scenes/splash'):build())
        end,
        onHover = function()
            S.scene:group('widgets').objects.playLabel.color = {255, 0, 0}
        end,
        onUnhover = function()
            S.scene:group('widgets').objects.playLabel.color = {255, 255, 255}
        end,
    })
    -- quit button
    group:addAs('quitLabel', require('entity.widgets.Label'){
        x = w/2, y = h/2 + 50, text = 'Quit'
    })
    group:addAs('quitButton', require('entity.widgets.Button'){
        x = w/2, y = h/2 + 50,
        w = group.objects.quitLabel.textObject:getWidth(),
        h = group.objects.quitLabel.textObject:getHeight(),
        onClick = love.event.quit,
        onHover = function()
            S.scene:group('widgets').objects.quitLabel.color = {255, 0, 0}
        end,
        onUnhover = function()
            S.scene:group('widgets').objects.quitLabel.color = {255, 255, 255}
        end,
    })
end})


S:addCallback('enter', function()
--idk what this does. emptied it.
end)

return S
