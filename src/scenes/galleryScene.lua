local gamestate = require 'lib.gamestate'
local SceneBuilder = require 'core.scenebuilder'

local w, h = love.graphics.getDimensions()
local background = assetmanager.backgrounds.menu
local layers = {
    bg = 0,
    card = 1,
    unit = 2,
    inf = 999,--debug value
}

local S = SceneBuilder()

function S:addGallery(cards,YesMinions)
    self:addObjectAs('gallery',{script = 'entity.Gallery', arguments = {
        scene = S.scene,
        z = layers.card,
        cards = cards,
        minions = YesMinions
    }})
end

function S:buildGallery(cards,YesMinions) --Number of players to create
    self:addGallery(cards,YesMinions)
    return self:build()
end

return S

