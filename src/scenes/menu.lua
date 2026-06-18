local gamestate = require 'lib.gamestate'
local lume = require 'lib.lume'
local SceneBuilder = require 'core.scenebuilder'
local Asteroid = require 'entity.asteroid'

local w, h = love.graphics.getDimensions()

local S = SceneBuilder()

S:addObjectAs('player',{
    script = 'entity.playerspaceship',
    arguments = {
    x=w/2,y=h/2,
    scene = S.scene,
    health = 5,
    shotColor = {255,255,255,255},
    }
})


S:addObjectAs('knight',{
    script = 'entity.player',
    arguments = {
    x=w/2-100,y=h/2-100,
    scene = S.scene,
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

--S:addCallback('enter', function()
 --   love.graphics.setBackgroundColor(0.078, 0.098, 0.137)
--end)

return S
