local Entity = require 'core.entity'
local label = require 'entity.label'
local conf = require 'conf'

local description = Entity:extend()

local charactersPerLine  = 100
local horizontalDistancing = 20
local middleOfScreen = conf.gamew/2

function description:init(o)
    o = o or {}
    Entity.init(self,o)

    self.text = o.text or "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    self.labels = self:createLines()
    self.startY = o.startY or 200
    self:setLabelPos()

end

function description:createLines()
    local output = {}
    local aLabel
    local subString
    local currentIndex = 1

    local reverseSpaceDex
    local spaceDex

    while true do
        if #self.text < currentIndex + charactersPerLine then
            subString = string.sub(self.text,currentIndex,#self.text)
            aLabel = label:new({text = subString})
            table.insert(output,aLabel)
            return output
        end

        subString = string.sub(self.text,currentIndex, currentIndex + charactersPerLine)

        reverseSpaceDex = string.find(string.reverse(subString)," ")--Obtain the last space
        spaceDex = string.len(subString) - reverseSpaceDex

        subString = string.sub(subString,1, spaceDex) --subString now ends exactly at the end of the last word that will fit

        currentIndex = currentIndex + spaceDex + 1
        aLabel = label:new({text = subString})

        table.insert(output,aLabel)
    end
end

function description:setLabelPos()
    local currentYoffSet = self.startY

    for _, v in ipairs(self.labels) do
        v.y = currentYoffSet
        currentYoffSet = currentYoffSet + horizontalDistancing

        v.x = middleOfScreen - (3*string.len(v.text)) - 5
    end
end

function description:draw()
    for _, v in ipairs(self.labels) do
        v:draw()
    end
end

return description