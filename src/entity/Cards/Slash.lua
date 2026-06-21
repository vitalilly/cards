local card = require 'entity.card'

local slash = card:extend()

function slash:init(o)
    card.init(self,o)
    o = o or {}

    self.targets = true
end
--target is the player this is played against
function slash:play(target) --Deal 4 damage to target player

    target.allSourcesOfDamage[self.player] = target.allSourcesOfDamage[self.player] + 4 --We use a key value pair using the player who played this card as the key and the amount of damage as the value.
end