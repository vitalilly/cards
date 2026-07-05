local Entity = require 'core.entity'

local card = Entity:extend()

local config = require 'conf'

function card:init(o) --Intitialise an instance of the card class
    Entity.init(self,o)
    o = o or {} --Give a blank table if no object is given

    self.title = o.title or ""
    self.image = o.image or love.graphics.newImage('assets/cardArt/Placeholder.png') --Implement a file that exists just to store all the assets
    self.textDescription = o.textDescription or ""
    self.player = o.player or {} --Descirbes the player to whom this card belongs to.
    self.targets = o.targets or false --Describes whether or not this card needs a target to work
    self.tag = o.tag or 0 --Describes what category this card falls into
    self.tagList = enum()
    self.x = -200
    self.y = config.gameh - config.cardHeight
end

function enum()
    return {None = 0, Attack = 1, Defend = 2, Minion = 3,Modifier = 4}
end

function card:damage(x,target) --Deal x damage to target player
        target.allSourcesOfDamage[self.player] = target.allSourcesOfDamage[self.player] + x --We use a key value pair using the player who played this card as the key and the amount of damage as the value.
end

function card:block(x) --block for x
    self.player.currentBlock = self.player.currentBlock + x
end

function card:play()
    print("This card should have this as an implementation")
end

function card:playTarget(target)
    print("This card should have this as an implementation")
end

function card:effect(list)
    print("This card has no implementation for an effect")
end

function card:SOT()
    print("This card has no implementation for a start of turn effect")
end

function card:EOT()
    print("This card has no implementation for end of turn effects")
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

return card



