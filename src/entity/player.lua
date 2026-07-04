local lume = require 'lib.lume'
local Entity = require 'core.entity'
local Timer = require 'core.timer'

local w, h = love.graphics.getDimensions()

local Player = Entity:extend()


-- sprite loading
local front = 
{
   love.graphics.newImage('assets/player/2/1.PNG'),
   love.graphics.newImage('assets/player/2/2.PNG'),
   love.graphics.newImage('assets/player/2/3.PNG'),
   love.graphics.newImage('assets/player/2/4.PNG'),
   love.graphics.newImage('assets/player/2/5.PNG'),
   love.graphics.newImage('assets/player/2/6.PNG'),
   love.graphics.newImage('assets/player/2/7.PNG'),
   love.graphics.newImage('assets/player/2/8.PNG'),
}
local active = {}

function Player:init(t)
	Entity.init(self,t)
	assert(t.x, 'x required')
	assert(t.y, 'y required')
	self.x = t.x
	self.y = t.y-100
	Player:turn(t.dir or "front")
end

function Player:turn(dir)
	if (dir == 'right') then 
        active = {unpack(right)}
    end

    if (dir == 'front') then
        active = {unpack(front)} 
    end
end

function Player:draw()
	love.graphics.push()
		love.graphics.translate(self.x, self.y)
		love.graphics.push()
			for _, v in ipairs(active) do
                love.graphics.draw(v)
            end
		love.graphics.pop()
	love.graphics.pop()
end
return Player
