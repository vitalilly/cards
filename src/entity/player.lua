local lume = require 'lib.lume'
local Entity = require 'core.entity'
local Timer = require 'core.timer'

local w, h = love.graphics.getDimensions()
local i = 1

local Player = Entity:extend()
local front = 
{
    dark='assets/player/front/DARK.PNG',
    hidark='assets/player/front/HIDARK.PNG',
    med='assets/player/front/MED.PNG',
    himed='assets/player/front/HIMED.PNG',
    light='assets/player/front/LIGHT.PNG',
    hilight='assets/player/front/HILIGHT.PNG',
    sat='assets/player/front/SAT.PNG',
    hisat='assets/player/front/HISAT.PNG',
    visor='assets/player/front/VISOR.PNG'
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
    	active = clone(front)
        for k,v in pairs(active) do
            print(v)
        end
    end
end
		

function Player:draw()
	love.graphics.setColor(1,1,1)
	love.graphics.push()
		love.graphics.translate(self.x, self.y)
		love.graphics.push()
			for k, v in pairs(front) do
				sprite = love.graphics.newImage(v)
                love.graphics.draw(sprite,100,100)
                if (i == 1) then
                    print(k)
                end
            end
		love.graphics.pop()
	love.graphics.pop()
    i = i+ 1
end

return Player
