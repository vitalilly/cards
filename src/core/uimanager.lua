--ui manager using helium

 --local class = require 'utils.class'
 local helium = require 'helium'
 local useState = require 'helium.hooks.state'--add states to components
 local input = require 'helium.core.input'
 local useButton = require 'helium.shell.button' --button shell
 local lume = require 'lib.lume'

 local UIManager = {}

 scene = helium.scene.new(true)
 scene:activate()

 buttonCreator = helium(function(param,view)
     local buttonState = useButton()
     input('clicked', function()
         if not buttonState.down then
             print('up')
         else
             print('down')
         end
     end)

     if onClick then
        print("a")
     end

     return function()
         love.graphics.setColor(8/255,0.4,0.6)
         love.graphics.rectangle('fill',0,0,view.w,view.h)
         love.graphics.setColor(1,1,1)
         love.graphics.print(param.text)
         --print(buttonState.over and 'Thanks!' or 'Hover over me...')
     end
 end)

 --store all scenes in  memory
 scenes = {}

--add a new scene to the manager
 --scene adding based on object-adding behaviour from core.pool
function UIManager.add(o)
    if o then
        scenes[o] = helium.scene.new(true) --create new scene at key
        scenes[o]:activate() --make the new scene active for drawing
        require ('scenes.ui.' .. tostring(o) .. 'UI') --draw the UI for the scene from file
        scene:activate() --reactivate previous scene
    end
    return o --this is in pool? probably for debugging purposes 
end

--Ensure a scene exists, then change the active scene accordingly
function UIManager.loadScene(o)
    if o then
        if not scenes[o] then UIManager.add(o); print('adding new scene') end --ensure scene exists
        scene  = scenes[o] --set the global scene to the one to be loaded
    end
    return o
end


return UIManager
