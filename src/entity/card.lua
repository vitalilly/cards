local Entity = require 'core.entity'

local card = Entity:extend()

function card:init(o) --Intitialise an instance of the card class
    Entity.init(self,o)
    o = o or {} --Give a blank table if no object is given

    self.image = o.image or ""
    self.textDescription = o.textDescription or ""
end

--TODO. Create a template that can be used for playing cards

return card



