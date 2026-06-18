local lume = require 'lib.lume'
local Entity = require 'core.entity'
local Timer = require 'core.timer'

local w, h = love.graphics.getDimensions()
local i = 1

local palette = require 'core.palette'
--testing that palette interface works
for k,v in ipairs(palette) do --for every colour,
    for j = 1,3 do --print the 3 RGB channels
        print(k,v[j])
    end
end

local Player = Entity:extend()
local front = 
{ --size restricted to 3 values to allow testing palette : asset mapping without making 9 colours
   'assets/player/front/DARK.PNG',
   'assets/player/front/HIDARK.PNG',
   'assets/player/front/MED.PNG',
--   'assets/player/front/HIMED.PNG',
--   'assets/player/front/LIGHT.PNG',
--   'assets/player/front/HILIGHT.PNG',
--   'assets/player/front/SAT.PNG',
--  'assets/player/front/HISAT.PNG',
--   'assets/player/front/VISOR.PNG'
}
local active = {}

local function clone(t)
    copy = { unpack(t) }
    return copy
end


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
        active = right
    end

    if (dir == 'front') then
    	active = clone(front) -- this doesn't work.
        active = front --nor does this.
        for k,v in pairs(active) do --this statement doesn't run: i suspect active is empty.
            print(v)
        end
    end
end
		

function Player:draw()
	love.graphics.setColor(1,1,1)
	love.graphics.push()
		love.graphics.translate(self.x, self.y)
		love.graphics.push()
			for i, v in ipairs(front) do
                love.graphics.setColor(palette[i])
				sprite = love.graphics.newImage(v)
                love.graphics.draw(sprite)
            end
            love.graphics.setColor(1,1,1)
		love.graphics.pop()
	love.graphics.pop()
end

return Player
