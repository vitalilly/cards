local lume = require 'lib.lume'
local Entity = require 'core.entity'
local Timer = require 'core.timer'

local w, h = love.graphics.getDimensions()

local Player = Entity:extend()


-- sprite loading
local front = assetmanager.sprites.units.knight
local quads = assetmanager.quads.rows[1]

function Player:init(t)
	Entity.init(self,t)
	assert(t.x, 'x required')
	assert(t.y, 'y required')
	self.x = t.x
	self.y = t.y-100
    self.tighten = t.tighten or 50
    self.active = ''
	self:turn(t.dir or "front")
    self.space = 0
    self.smaller = false
end

function Player:turn(dir)
	if (dir == 'right') then 
        self.active = (right)
    end

    if (dir == 'front') then
        self.active = front
    end
end

function Player:Accordian(active, type)
    if not active then
        return 0
    end

    if self.smaller then
        type = type - 1
        if type == 0 then
            self.smaller = false
        end
    else
        type = type + 1
        if type == 300 then
            self.smaller = true
        end
    end
    return type
end

function Player:draw()
	love.graphics.push()
		love.graphics.translate(self.x, self.y)
		love.graphics.push()
			for _, q in ipairs(quads) do
                love.graphics.draw(self.active,q)
            end
		love.graphics.pop()
	love.graphics.pop()
end
return Player
