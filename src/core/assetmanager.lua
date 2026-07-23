local class = require 'utils.class'
local assetManager = {sprites = {},
buttons = {},
cardArt = {},
players = {}}

assetManager.backgrounds = {
    menu = love.graphics.newImage("assets/img/menu.png")
}

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
--quads!! hierarchy is quads -> dimensions -> rows[quads 1-8]
--but dimensions is omitted because we only have one atlas lol
assetManager.quads = {rows = {[1] = {} } }
for i = 1,8 do
    assetManager.quads.rows[1][i] = love.graphics.newQuad(32*(i-1),1,32,32,unpack(atlasDimensions.default)) 
end

--print to debug what the unpack outputs <3 (IT WORKS HERE !!)
--print(unpack(atlasDimensions.default))

assetManager.buttons = {
    ["LeftArrow"] = love.graphics.newImage('assets/buttons/leftArrow.png'),
    ["RightArrow"] = love.graphics.newImage('assets/buttons/rightArrow.png')
}

assetManager.cardArt = {
    ["Placeholder"] = love.graphics.newImage('assets/cardArt/Placeholder.png'),
}

assetManager.players = {
    ["Player1"] = love.graphics.newImage('assets/player/player1.png'),
    ["Player2"] = love.graphics.newImage('assets/player/player2.png'),
    ["Player3"] = love.graphics.newImage('assets/player/player3.png'),
    ["Player4"] = love.graphics.newImage('assets/player/player4.png')
}

function assetManager:getCardArt(cardName)
    return self.cardArt[cardName]
end

return assetManager
