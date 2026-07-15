local class = require 'utils.class'
local assetManager = {}

assetManager.sprites = {
    units = {
        knight = love.graphics.newImage("assets/knight/atlas.png")
    },
    cards = { base = "",
        art = {
        }
    },
}

--quad dimensions for a horizontal sheet of 32x32 sprites (see knight's atlas)
local atlasDimensions = {
    default = {258,34}
}
assetManager.quads = {}
for i = 1,8 do
    assetManager.quads[i] = love.graphics.newQuad(32*(i-1),1,32,32,unpack(atlasDimensions.default)) 
end

--print to debug what the unpack outputs <3 (IT WORKS HERE !!)
--print(unpack(atlasDimensions.default))

assetManager.cardArt = {
    ["Placeholder"] = love.graphics.newImage('assets/cardArt/Placeholder.png'),
}

function assetManager:getCardArt(cardName)
    return self.cardArt[cardName]
end

return assetManager
