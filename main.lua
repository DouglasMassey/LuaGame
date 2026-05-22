-- main.lua
SceneManager = require('scenemanager')

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setTitle("Hello World")
    love.window.setIcon(love.image.newImageData("assets/duck_small_static_facing_right.png"))
    love.graphics.setBackgroundColor(0, 0.6, 1)
    local width, height = love.window.getDesktopDimensions()
    love.window.setMode(width, height - 50, {
        fullscreen = false,
        resizable = true,
        borderless = false
    })
    SceneManager.change('menu')
end

function love.update(dt)
    SceneManager.update(dt)
end

function love.draw()
    SceneManager.draw()
end

function love.keypressed(key)
    SceneManager.keypressed(key)
end
