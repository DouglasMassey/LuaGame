local SceneManager = {}
local currentScene = nil

function SceneManager.change(sceneName)
    if currentScene and currentScene.exit then
        currentScene:exit()
    end
    currentScene = require('scenes/' .. sceneName)
    if currentScene.load then
        currentScene:load()
    end
end

function SceneManager.update(dt)
    if currentScene and currentScene.update then
        currentScene:update(dt)
    end
end

function SceneManager.draw()
    if currentScene and currentScene.draw then
        currentScene:draw()
    end
end

function SceneManager.keypressed(key)
    if currentScene and currentScene.keypressed then
        currentScene:keypressed(key)
    end
end

function SceneManager.mousepressed(x, y, button)
    if currentScene and currentScene.mousepressed then
        currentScene:mousepressed(x, y, button)
    end
end

return SceneManager
