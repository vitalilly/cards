local config = {}

config.gamew = 640
config.gameh = 360
config.windoww = 1280
config.windowh = 720

config.cardHeight = 45
config.cardWidth = 100

config.globalPalette = 3 -- [1-4]

function love.conf(t)
    t.window.title = "Untitled Card Game"
    t.window.width = 1280
    t.window.height = 720
    io.stdout:setvbuf("no")
end

return config
