local class = require 'utils.class'
local assetManager = {}

assetManager.cardArt = {
    ["Placeholder"] = love.graphics.newImage('assets/cardArt/Placeholder.png'),
}

function assetManager:getCardArt(cardName)
    return self.cardArt[cardName]
end

return assetManager