local lume = require 'lib.lume'
local Entity = require 'core.entity'
local Timer = require 'core.timer'

local w, h = love.graphics.getDimensions()

local Player = Entity:extend()


-- sprite loading
local front = 
{
<<<<<<< HEAD
   love.graphics.newImage('assets/player/2/1.PNG'),
   love.graphics.newImage('assets/player/2/2.PNG'),
   love.graphics.newImage('assets/player/2/3.PNG'),
   love.graphics.newImage('assets/player/2/4.PNG'),
   love.graphics.newImage('assets/player/2/5.PNG'),
   love.graphics.newImage('assets/player/2/6.PNG'),
   love.graphics.newImage('assets/player/2/7.PNG'),
   love.graphics.newImage('assets/player/2/8.PNG'),
=======
   [1] = love.graphics.newImage('assets/player/2/1.PNG'),
   [2] = love.graphics.newImage('assets/player/2/2.PNG'),
   [3] = love.graphics.newImage('assets/player/2/3.PNG'),
   [4] = love.graphics.newImage('assets/player/2/4.PNG'),
   [5] = love.graphics.newImage('assets/player/2/5.PNG'),
   [6] = love.graphics.newImage('assets/player/2/6.PNG'),
   [7] = love.graphics.newImage('assets/player/2/7.PNG'),
   [8] = love.graphics.newImage('assets/player/2/8.PNG')
>>>>>>> 54892ed5724f46689611cac6d68330bb02709892
}

function Player:init(t)
	Entity.init(self,t)
	assert(t.x, 'x required')
	assert(t.y, 'y required')
	self.x = t.x
	self.y = t.y-100
    self.tighten = t.tighten or 50
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
    self.tighten = self:Accordian(false, self.tighten)
    self.space = self:Accordian(false, self.space)
	love.graphics.push()
		love.graphics.translate(self.x, self.y)
		love.graphics.push()
<<<<<<< HEAD
			for _, v in ipairs(active) do
                love.graphics.draw(v)
=======
			for i, v in ipairs(self.active) do
                love.graphics.draw(v,0+(i*self.tighten) + self.space,0)
>>>>>>> 54892ed5724f46689611cac6d68330bb02709892
            end
		love.graphics.pop()
	love.graphics.pop()
end
return Player
