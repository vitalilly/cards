local config = require 'conf'
local Entity = require 'core.entity'

local page = Entity:extend()

local rows = 3
local collumns = 5

local border = 20
local wideBorder = 40 --Wider border at the bottom to make room for text description of cards when hovered over

local function getGrid() --Run this function and store the result statically to reduce computationism
    local grid = {}
    local workableX = config.gamew - (border*2) --Get the space the cards may be in horiztonally as an int
    local workableY = config.gameh - border - wideBorder --Get the space the cards may be in vertically as an int
    for i = 1, rows, 1 do
        for j = 1, collumns, 1 do
            local x = (j-1)*math.floor(workableX/collumns) + border
            local y = (i-1)*math.floor(workableY/rows) + border
            local coords = {x = x, y = y}
            table.insert(grid,coords) --Building the array as a straight line to make card placement easier as we will just place cards in the order of the array.
        end
    end
    return grid
end

local grid = getGrid()

function page:init(o)
    o = o or {}
    Entity.init(self,o)

    self.cards = o.cards or {}
    self.minions = o.minions or false
end

function page.getDimensions()
    return rows,collumns
end

function page:draw()
    local startPoint
    if not self.minions then
        startPoint = 1 + collumns
    else
        startPoint = 1
    end

    for i = startPoint, #self.cards, 1 do
        local card = self.cards[i]
        local coords = grid[i]
        if not self.minions then
            card:drawAt(coords.x,coords.y)
        else
            card:drawMinion(coords.x,coords.y)
        end
    end
end

return page



