local duckcounting = {}

function duckcounting:load()
    -- Load assets, initialize variables, etc.
end

function duckcounting:update(dt)
    -- Update game logic
end

function duckcounting:draw()
    love.graphics.print("Duck Counting Scene", 100, 100)
end

function duckcounting:keypressed(key)
    if (key == 'escape') then
        SceneManager.change('menu')
    end
end

return duckcounting
