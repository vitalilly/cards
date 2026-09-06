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

function S:addGallery(cards)
    self:addObjectAs('gallery',{script = 'entity.Gallery', arguments = {
        scene = S.scene,
        z = layers.card,
        cards = cards,
    }})
end

function S:buildGallery(cards) --Number of players to create
    self:addGallery(cards)
    return self:build()
end

return S

