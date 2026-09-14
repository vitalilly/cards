local Card = require 'entity.card'
local assetmanager = require 'core.assetmanager'

local minion = Card:extend()

function minion:init(o) --Intitialise an instance of the card class
    Card.init(self,o)
    o = o or {} --Give a blank table if no object is given

    self.health = o.health or 0
    self.minionArt = o.minionArt or assetmanager.minionArt["Placeholder"]
    self.effectTagList = self.effectEnum()
    self.effectTags = {}
    table.insert(self.effectTags,self.effectTagList.None) --Default to no effect
end

function minion.effectEnum()
    return {None = 0, SOT = 1 , effect = 2, EOT = 3}
end

function minion.contains(table,elements)
    for i = 1, #table, 1 do
        if table[i] == elements then
            return true
        end
    end
    return false
end

function minion:play()
    print(self.title .. " this card should have a play implementation")
end

function minion:minionPlay()
    table.insert(self.player.minions,self)

    if self.contains(self.effectTags,self.effectTagList.None) then
        return --No effect to add to the player
    end

    if self.contains(self.effectTags,self.effectTagList.SOT) then
        table.insert(self.player.effectsSOT,self)
    end

    if self.contains(self.effectTags,self.effectTagList.effect) then
        table.insert(self.player.effects,self)
    end

    if self.contains(self.effectTags,self.effectTagList.EOT) then
        table.insert(self.player.effectsEOT,self)
    end


end

function minion:TakeTheHit(damage)
    self.health = self.health - damage --TODO Display some animation of the minion taking damage with feedback for exactly how much it was

    if self.health == 0 then
        self:death()
    end

    if self.health <= 0 then
        return 0 --Represents that all the damage has been taken
    else  --Damage is less than 0
        self:death()
        return -self.health --Thinking this will return the positive version of the health so we know how much damage needs to go to the next minion
    end
end

function minion:minionDeath()
    self:removeFrom(self.player.minions)

    if self.contains(self.effectTags,self.effectTagList.None) then
        return --No effect to add to the player
    end

    if self.contains(self.effectTags,self.effectTagList.SOT) then
        self:removeFrom(self.player.effectsSOT)
    end

    if self.contains(self.effectTags,self.effectTagList.effect) then
        self:removeFrom(self.player.effects)
    end

    if self.contains(self.effectTags,self.effectTagList.EOT) then
        self:removeFrom(self.player.effectsEOT)
    end

end

function minion:drawMinion(x,y)
    love.graphics.draw(self.minionArt,x,y)
end

return minion
