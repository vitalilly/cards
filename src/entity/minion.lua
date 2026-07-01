local Card = require 'entity.card'

local minion = Card:extend()

function minion:init(o) --Intitialise an instance of the card class
    Card.init(self,o)
    o = o or {} --Give a blank table if no object is given

    self.health = o.health or 0
end

function minion:TakeTheHit(damage)
    self.health = self.health - damage --TODO Display some animation of the minion taking damage with feedback for exactly how much it was

    if self.health == 0 then
        self:death()
    end

    if self.health >= 0 then
        return 0 --Represents that all the damage has been taken
    else  --Damage is less than 0
        --TODO death behavior
        return -self.health --Thinking this will return the positive version of the health so we know how much damage needs to go to the next minion
    end
end

function minion:death()
    print("no implementation for death of this card exists yet")
end

return minion
