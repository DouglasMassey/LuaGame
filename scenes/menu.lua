local menu = {}

--#region Text Variables
local fontSize = 90
local textXfactor = 0.5
local textYfactor = 0.06
local text = "Duck Duck"
local textSize = 1.5
local debugTextSize = 0.2
local textSpeed = 0.5
--#endregion

--#region Lake Shader Variables
local lakeShader = nil
local shaderTime = 0
--#endregion

--#region Ripple Variables
local RippleSheet = nil
local rippleQuads = {}
local ripples = {}
local rippleFrameWidth = 480    -- Adjust based on your spritesheet
local rippleFrameHeight = 480   -- Adjust based on your spritesheet
local rippleFrameCount = 8      -- Adjust based on your spritesheet
local rippleAnimSpeed = 0.06    -- Time per frame
local rippleSpawnTimer = 0
local rippleSpawnInterval = 0.1 -- Base interval in seconds
local lastMouseX, lastMouseY = 0, 0
local isMouseMoving = false
local mouseMovementThreshold = 1
local rippleSound = nil -- Sound effect for ripple spawn
--#endregion

--#region Thumbnail Variables
local thumbnailSize = 3
--#endregion

--#region Button Variables
local buttons = {}
--#endregion

DuckImage = love.graphics.newImage("assets/duck_small_static_facing_right.png")
CountingDucksThumbnail = love.graphics.newImage("assets/duck_counting_thumbnail.png")
SolidWhiteThumbnail = love.graphics.newImage("assets/solid_white_thumbnail.png")

function menu:load()
    Basicpixelfont = love.graphics.setNewFont("fonts/basic_pixel_font.ttf", fontSize)
    love.graphics.setFont(Basicpixelfont)
    TextX = textXfactor * love.graphics.getWidth()
    TextY = textYfactor * love.graphics.getHeight()

    -- Load lake shader
    lakeShader = love.graphics.newShader("lake_shader.glsl")
    shaderTime = 0

    -- Load ripple spritesheet
    RippleSheet = love.graphics.newImage("assets/ripple_spritesheet.png")
    local sheetWidth = RippleSheet:getWidth()
    local sheetHeight = RippleSheet:getHeight()

    -- Create quads for each frame (assuming horizontal spritesheet)
    for i = 0, rippleFrameCount - 1 do
        local quad = love.graphics.newQuad(
            i * rippleFrameWidth,
            0,
            rippleFrameWidth,
            rippleFrameHeight,
            sheetWidth,
            sheetHeight
        )
        table.insert(rippleQuads, quad)
    end

    -- Initialize mouse position
    lastMouseX, lastMouseY = love.mouse.getPosition()

    -- Load ripple sound
    rippleSound = love.audio.newSource("assets/sounds/loud_water_drop.mp3", "static")
    CentreScreen = {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2
    }

    -- Initialize buttons
    buttons = {
        {
            x = CentreScreen.x - CountingDucksThumbnail:getWidth() * thumbnailSize - (thumbnailSize * 10),
            y = TextY + 250,
            width = CountingDucksThumbnail:getWidth(),
            height = CountingDucksThumbnail:getHeight(),
            xScale = thumbnailSize,
            yScale = thumbnailSize,
            rotation = 0,
            onClick = function() SceneManager.change('duckcounting') end,
            isHovered = false,
            isSelected = false,
            image = CountingDucksThumbnail
        },
        {
            x = CentreScreen.x + (thumbnailSize * 10),
            y = TextY + 250,
            width = CountingDucksThumbnail:getWidth(),
            height = CountingDucksThumbnail:getHeight(),
            xScale = thumbnailSize,
            yScale = thumbnailSize,
            rotation = 0,
            onClick = nil,
            isHovered = false,
            isSelected = false,
            image = CountingDucksThumbnail
        }
    }
end

function menu:draw()
    CentreScreen = {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2
    }
    --#region SHADERS
    if lakeShader then
        lakeShader:send("time", shaderTime)
        lakeShader:send("pixelSize", 32.0)
        lakeShader:send("waveFrequency", 0.001)
        lakeShader:send("waveSpeed", 0.4)
        lakeShader:send("waveAmplitude", 0.5)
        lakeShader:send("waveOffset", 0.5)
        lakeShader:send("colorThreshold", 0.5)
        love.graphics.setShader(lakeShader)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setShader()
    end



    --#endregion

    --#region Draw ripples first (behind other content)
    for _, ripple in ipairs(ripples) do
        local frame = math.floor(ripple.currentFrame) + 1
        if frame <= #rippleQuads then
            -- Calculate fade out based on animation progress
            local progress = ripple.currentFrame / rippleFrameCount
            local alpha = 1 - progress -- Fade from 1 to 0

            love.graphics.setColor(1, 1, 1, alpha)
            love.graphics.draw(
                RippleSheet,
                rippleQuads[frame],
                ripple.x,
                ripple.y,
                0,
                ripple.scale,
                ripple.scale,
                rippleFrameWidth / 2,          -- Center origin X
                rippleFrameHeight / 2          -- Center origin Y
            )
            love.graphics.setColor(1, 1, 1, 1) -- Reset color
        end
    end
    --#endregion

    TextX = textXfactor * love.graphics.getWidth()
    TextY = textYfactor * love.graphics.getHeight()
    local startX = TextX - (Basicpixelfont:getWidth(text) / 2) * textSize
    local startY = TextY
    local time = love.timer.getTime()

    -- Draw animated title
    for i = 1, #text do
        local char = text:sub(i, i)

        -- Calculate a unique Y offset based on time and character index
        local offsetY = math.sin(time * 4 + i * textSpeed) * 4

        love.graphics.print(char, startX, startY + offsetY, 0, textSize, textSize)

        -- Move startX forward by the width of the character so they don't overlap
        startX = startX + Basicpixelfont:getWidth(char) * textSize
    end
    local offsetY = math.sin(time * 4 + (#text + 1) * textSpeed) * 4
    love.graphics.draw(DuckImage, startX, TextY + offsetY,
        0, 0.3, 0.3)


    --#region Draw buttons
    for i, button in ipairs(buttons) do
        if button.image then
            if button.isSelected then
                love.graphics.setBlendMode("alpha")
                love.graphics.setColor(1, 0.5, 1, 1)
                love.graphics.draw(
                    SolidWhiteThumbnail,
                    button.x + 15,
                    button.y + 15,
                    button.rotation,
                    button.xScale,
                    button.yScale * 1.01
                )
                love.graphics.setBlendMode("alpha")
                love.graphics.setColor(1, 1, 1, 1)
            end
            love.graphics.setColor(0.9, 0.9, 0.9, 1)
            love.graphics.draw(
                button.image,
                button.x,
                button.y,
                button.rotation,
                button.xScale,
                button.yScale
            )
            -- Draw hover effect
            if button.isHovered or button.isSelected then
                love.graphics.setBlendMode("add")
                love.graphics.setColor(1, 1, 1, 0.1)
                love.graphics.draw(
                    button.image,
                    button.x,
                    button.y,
                    button.rotation,
                    button.xScale,
                    button.yScale
                )
                love.graphics.setBlendMode("alpha")
                love.graphics.setColor(1, 1, 1, 1) -- Reset color
            end
        end
    end
    --#endregion

    --#region Debug: Show buttons table
    love.graphics.setColor(1, 1, 1, 1)
    local debugText = "Buttons: "
    for i, button in ipairs(buttons) do
        debugText = debugText .. string.format(
            "\n[%d] x=%.0f y=%.0f w=%.0f h=%.0f xScale=%.1f yScale=%.1f rot=%.1f hover=%s sel=%s",
            i, button.x, button.y, button.width, button.height,
            button.xScale, button.yScale, button.rotation,
            tostring(button.isHovered), tostring(button.isSelected)
        )
    end
    love.graphics.print(debugText, 0, 0, 0, debugTextSize, debugTextSize)
    --#endregion
end

function menu:update(dt)
    -- Update shader animation time
    shaderTime = shaderTime + dt

    local mouseX, mouseY = love.mouse.getPosition()

    -- Update button hover states
    for i, button in ipairs(buttons) do
        local inBounds = mouseX >= button.x and mouseX <= button.x + (button.width * button.xScale) and
            mouseY >= button.y and mouseY <= button.y + (button.height * button.yScale)
        button.isHovered = inBounds
    end

    -- Check if mouse is moving
    local dx = mouseX - lastMouseX
    local dy = mouseY - lastMouseY
    local distance = math.sqrt(dx * dx + dy * dy)
    isMouseMoving = distance > mouseMovementThreshold

    -- create ripples while mouse is moving
    if isMouseMoving then
        rippleSpawnTimer = rippleSpawnTimer + dt

        if rippleSpawnTimer >= rippleSpawnInterval then
            -- Create a new ripple
            local firstRippleScale = 0.1 + math.random() * 0.4 -- Adjust scale as needed
            local newRipple = {
                x = mouseX,
                y = mouseY,
                currentFrame = 0,
                scale = firstRippleScale
            }
            table.insert(ripples, newRipple)
            if (math.random() < 0.2) then
                local newRipple = {
                    x = mouseX + (math.random() * 20 - 10),
                    y = mouseY + (math.random() * 20 - 10),
                    currentFrame = 0,
                    scale = firstRippleScale * 0.6
                }
                table.insert(ripples, newRipple)
                -- Play sound with random pitch
                local soundClone = rippleSound:clone()
                soundClone:setPitch(1 + math.random() * 1) -- Random pitch between 0.8 and 1.6
                soundClone:setVolume(0.02)                 -- Adjust volume as needed
                soundClone:play()
            end
            rippleSpawnTimer = 0
            rippleSpawnInterval = 0.05 + math.random() * 0.08
        end
    end

    -- Update all active ripples
    for i = #ripples, 1, -1 do
        local ripple = ripples[i]
        ripple.currentFrame = ripple.currentFrame + (dt / rippleAnimSpeed)
        if ripple.currentFrame >= rippleFrameCount then
            table.remove(ripples, i)
        end
    end

    -- Update last mouse position
    lastMouseX, lastMouseY = mouseX, mouseY
end

function menu:keypressed(key)
    if key == 'return' then
        SceneManager.change('duckcounting')
    end
end

function menu:mousepressed(x, y, button)
    if button == 1 then -- Left click
        for i, btn in ipairs(buttons) do
            if btn.isHovered then
                if btn.onClick then
                    btn.onClick()
                else
                    btn.isSelected = not btn.isSelected
                end
                break
            end
        end
    end
end

return menu
