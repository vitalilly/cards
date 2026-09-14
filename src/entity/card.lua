local Entity = require 'core.entity'

local card = Entity:extend()

local config = require 'conf'
local assetManager = require 'core.assetmanager'

local defaultX = -config.cardWidth - 20
local defaultY = config.gameh - config.cardHeight

function card:init(o) --Intitialise an instance of the card class
    o = o or {} --Give a blank table if no object is given
    Entity.init(self,o)

    self.title = o.title or ""
    self.image = o.image or assetManager:getCardArt("Placeholder")
    self.textDescription = o.textDescription or ""
    self.player = o.player or {} --Descirbes the player to whom this card belongs to.
    self.targets = o.targets or false --Describes whether or not this card needs a target to work
    self.tag = o.tag or 0 --Describes what category this card falls into
    self.tagList = self.tagEnum()
    self.x = defaultX
    self.y = defaultY
    self.selected = o.selected or false --The card is being hovered over
    self.grabbed = o.grabbed or false --The card is being grabbed
    self.entered = o.entered or false --The card has been placed in the hand correctly
end

function card.tagEnum()
    return {None = 0, Attack = 1, Defend = 2, Minion = 3,Modifier = 4}
end

function card:resetPosition()
    self.x = defaultX
    self.y = defaultY
end

function card:damage(x,target) --Deal x damage to target player
    target.allSourcesOfDamage[self.player] = target.allSourcesOfDamage[self.player] + x --We use a key value pair using the player who played this card as the key and the amount of damage as the value.
    print(target.allSourcesOfDamage[self.player])
end

function card:block(x) --block for x
    self.player.currentBlock = self.player.currentBlock + x
end

function card:play()
    print(self.title .. "This card should have this as an implementation")
end

function card:playTarget(target)
    print(self.title .."This card should have this as an implementation")
end

function card:effect(list)
    print(self.title .."This card has no implementation for an effect")
end

function card:SOT()
    print(self.title .."This card has no implementation for a start of turn effect")
end

function card:EOT()
    print(self.title .."This card has no implementation for end of turn effects")
end

function card:removeFrom(list)
    for i, v in ipairs(list) do
        if v == self then
            table.remove(list, i)
            break
        end
    end
end

function card:draw()
    love.graphics.draw(self.image,self.x,self.y)
end

function card:drawAt(x,y)
    love.graphics.draw(self.image,x,y)
end

return card



