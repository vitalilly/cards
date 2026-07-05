--instantiates push & the palette/shader for use in all scenes
--push section
do
push = require 'lib.push' 
local config = require 'conf'

love.graphics.setDefaultFilter("nearest", "nearest") --disable blurry scaling
  
local gamew, gameh = config.gamew, config.gameh
local w, h = love.graphics.getDimensions()

push:setupScreen(gamew, gameh, w, h, {
    fullscreen = false,
    resizable = true
    ,pixelperfect = true
    ,canvas = true
})

--palette handling
local palette = require 'core.palette'
local palette = palette:select(config.globalPalette)
local cpalette = {unpack(palette)}
for i = 1,8 do 
    cpalette[i] = {love.math.colorFromBytes(palette[i])}
end

--shader handling
shader = love.graphics.newShader(require 'core.shader') 
shader:send("colors", unpack(cpalette))
end
