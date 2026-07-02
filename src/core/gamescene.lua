io.stdout:setvbuf('no') --idk what this does.

local lume = require 'lib.lume'
local Camera = require 'core.camera'
local Pool = require 'core.pool'

--push section
local push = require 'lib.push' 
love.window.setTitle("scene demo")

love.graphics.setDefaultFilter("nearest", "nearest") --disable blurry scaling
  
local gamew, gameh = 640, 360 
local w, h = love.graphics.getDimensions()

push:setupScreen(gamew, gameh, w, h, {
    fullscreen = false,
    resizable = true
    --pixelperfect = true
})

--palette handling
palette = require 'core.palette'
palette = palette:select(1)
local cpalette = {unpack(palette)}
for i = 1,8 do 
    cpalette[i] = {love.math.colorFromBytes(palette[i])}
end

--shader handling
shader = love.graphics.newShader(require 'core.shader') 
shader:send("colors", unpack(cpalette))

--canvas handling
push:setupCanvas({
    {name = 'main_canvas'}
})

--resize callback override
function love.resize(w,h)
    push:resize(w,h)
end

--

local GameScene = Pool:extend()

local init = GameScene.init
function GameScene:init()
    init(self)
    self.updateActions = {}
    self.camera = Camera()
    self:addAs('timer', require('core.timer').global)
    self:setup()
    push:setShader( shader ) --this is done in love.load() in the example: must be done during runtime?
end

--- callback, called in GameScene:init()
function GameScene:setup() end

function GameScene:addUpdateAction(action)
    lume.push(self.updateActions, action)
end

local update = Pool.update
function GameScene:update(dt)
    update(self, dt)
    for _, action in ipairs(self.updateActions) do action(self, dt) end
end

local draw = GameScene.draw
function GameScene:draw()
    push:apply("start")
  --  self.camera:set()
    draw(self)
  --  self.camera:unset()
    push:apply("end")
end

--- creates a new group and the associated add/remove helper methods
function GameScene:createGroup(name, t)
    local group = Pool(t)
    local add = group.add
    function group:add(o)
        if o then lume.push(o.groups, self) end
        return add(self, o)
    end
    self:addAs('group_' .. name, group)
    return group
end

function GameScene:group(name)
    return self.objects['group_' .. name]
end

local each = GameScene.each
function GameScene:eachObject() return each(self) end

function GameScene:each(groupName)
    local group = self:group(groupName)
    if group then return group:each()
    else return pairs{} end
end

return GameScene
