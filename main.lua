--#region Text Variables
local fontSize = 90
local textWidth = 500
local textXfactor = 0.5
local textYfactor = 0.06
local textRotation = -math.pi / 9
local text = "Duck Duck"
local textSize = 1
local debugTextSize = 0.2
local textMinSize = 1
local textMaxSize = 1.2
local textSpeed = 0.5
--#endregion
function love.load()
    love.window.setTitle("Hello World")
    local width, height = love.window.getDesktopDimensions()
    love.window.setMode(width, height - 50, {
        fullscreen = false,
        resizable = true,
        borderless = false
    })
    basicpixelfont = love.graphics.setNewFont("fonts/basic_pixel_font.ttf", fontSize)
    love.graphics.setFont(basicpixelfont)
    TextX = textXfactor * love.graphics.getWidth()
    TextY = textYfactor * love.graphics.getHeight()
end

function love.draw()
    TextX = textXfactor * love.graphics.getWidth()
    TextY = textYfactor * love.graphics.getHeight()
    --DrawSplashText()
    local startX = TextX - basicpixelfont:getWidth(text) / 2
    local startY = TextY
    local time = love.timer.getTime()

    -- Draw animated title
    for i = 1, #text do
        local char = text:sub(i, i)

        -- Calculate a unique Y offset based on time and character index
        local offsetY = math.sin(time * 4 + i * 0.5) * 4

        love.graphics.print(char, startX, startY + offsetY, 0, textSize, textSize)

        -- Move startX forward by the width of the character so they don't overlap
        startX = startX + basicpixelfont:getWidth(char)
    end
    --#region interactive title underline
    love.graphics.rectangle("line", TextX - basicpixelfont:getWidth(text) / 2, TextY + 110, basicpixelfont:getWidth(text),
        8)
    local mouseX, mouseY = love.mouse.getPosition()
    local underlineX = TextX - basicpixelfont:getWidth(text) / 2
    local underlineEndX = TextX + basicpixelfont:getWidth(text) / 2
    local smallRectWidth = 30
    -- Clamp mouseX to stay within the underline bounds
    local clampedX = math.max(underlineX, math.min(underlineEndX - smallRectWidth, mouseX - (smallRectWidth / 2)))
    love.graphics.rectangle("fill", clampedX, TextY + 110, smallRectWidth,
        8)

    --#endregion
    love.graphics.print("mouse x: " .. mouseX, 0, 0 + 18, 0, debugTextSize, debugTextSize)
    love.graphics.print(("window width / 2: " .. love.graphics.getWidth() / 2), 0, 0 + 54, 0, debugTextSize,
        debugTextSize)
end

function love.update(dt)

end
