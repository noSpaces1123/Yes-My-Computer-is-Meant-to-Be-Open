love.window.setMode(0,0, {fullscreen = true, highdpi = true})

WINDOW = {
    WIDTH = love.graphics.getWidth(), HEIGHT = love.graphics.getHeight(),
    CENTER_X = love.graphics.getWidth() / 2, CENTER_Y = love.graphics.getHeight() / 2,
}

function love.load()
    love.graphics.setBackgroundColor(1,1,1)


    Text = "Yes, my computer is meant to be open."
    Subtext = "Please don't touch. You're being watched."

    Fonts = {
        text = love.graphics.newFont("Inter/static/Inter_28pt-ExtraBold.ttf", 50),
        subtext = love.graphics.newFont("Inter/static/Inter_28pt-ThinItalic.ttf", 20),
        small = love.graphics.newFont("Inter/static/Inter_28pt-ThinItalic.ttf", 16),
    }

    MousePositionLastFrame = { love.mouse.getX(), love.mouse.getY() }

    Redness = 0

    InteractedWith = false
    InteractedWithAt = -1

    local dateTable = os.date("*t")
    LastOpened = dateTable.hour .. ":" .. dateTable.min
end

function love.update(dt)
    -- redness
    local maxDistance = 100
    local magnitude = Distance(MousePositionLastFrame[1], MousePositionLastFrame[2], love.mouse.getX(), love.mouse.getY()) / maxDistance

    Redness = Redness + magnitude / 8
    if Redness > 1 then
        Redness = 1
    end
    love.graphics.setBackgroundColor(1, 1 - Redness, 1 - Redness)

    if Redness > 0 and magnitude <= 0 then
        Redness = Redness - 0.05 * dt * 60
        if Redness < 0 then
            Redness = 0
        end
    end

    MarkAsInteractedWithIf(magnitude > 0)

    MousePositionLastFrame = { love.mouse.getX(), love.mouse.getY() }
end

function love.draw()
    local function jitter(amplitude) return math.random(-amplitude, amplitude) end
    love.graphics.translate(jitter(Redness*2), jitter(Redness*2))

    local spacing = 20
    local padding = 10

    love.graphics.setColor(0,0,0)
    love.graphics.setFont(Fonts.text)
    love.graphics.printf(Text, 0, WINDOW.CENTER_Y - Fonts.text:getHeight() / 2, WINDOW.WIDTH, "center")

    love.graphics.setFont(Fonts.subtext)
    love.graphics.printf(Subtext, 0, WINDOW.CENTER_Y + Fonts.text:getHeight() / 2 + spacing, WINDOW.WIDTH, "center")

    love.graphics.setFont(Fonts.small)
    love.graphics.print("This computer has " .. (InteractedWith and "last" or "not") .. " been interacted with" .. (InteractedWith and " at " .. InteractedWithAt .. "." or "."), padding, WINDOW.HEIGHT - Fonts.small:getHeight() * 2 - padding * 1.5)
    love.graphics.print("Opened at " .. LastOpened .. ".", padding, WINDOW.HEIGHT - Fonts.small:getHeight() - padding)

    love.graphics.origin()
end

function Distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function MarkAsInteractedWithIf(bool)
    if not bool then return end
    InteractedWith = true

    local dateTable = os.date("*t")
    InteractedWithAt = dateTable.hour .. ":" .. dateTable.min
end

function love.mousepressed()
    MarkAsInteractedWithIf(true)
    Redness = 1
end

function love.keypressed(key)
    if key == "escape" then love.event.quit() return end
    MarkAsInteractedWithIf(true)
    Redness = 1
end

function love.focus(focus)
    MarkAsInteractedWithIf(not focus)
    if not focus then Redness = 1 end
end