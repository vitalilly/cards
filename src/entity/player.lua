local lume = require 'lib.lume'
local Entity = require 'core.entity'
local Timer = require 'core.timer'

local w, h = love.graphics.getDimensions()
local i = 1

local Player = Entity:extend()
--status, message = love.graphics.validateShader(true, require  'core.shader')
--print(status, message)


-- sprite loading
local front = 
{
   'assets/player/2/1.PNG',
   'assets/player/2/2.PNG',
   'assets/player/2/3.PNG',
   'assets/player/2/4.PNG',
   'assets/player/2/5.PNG',
   'assets/player/2/6.PNG',
   'assets/player/2/7.PNG',
   'assets/player/2/8.PNG',
 --  'assets/player/2/0.PNG',
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
    love.graphics.setColor(1,1,1)
	love.graphics.push()
		love.graphics.translate(self.x, self.y)
		love.graphics.push()
			for i, v in ipairs(active) do
				sprite = love.graphics.newImage(v)
                love.graphics.draw(sprite)
            end
		love.graphics.pop()
	love.graphics.pop()
end

return Player
