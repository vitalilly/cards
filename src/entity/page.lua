local Entity = require 'core.entity'

local page = Entity:extend()

function page:init(o)
    o = o or {}
    Entity.init(self,o)

    self.rows = o.rows or 10
    self.collumns = o.collumns

    self.cards = {}
end

function page:addCard(card)
    table.insert(self.cards,card)
end

