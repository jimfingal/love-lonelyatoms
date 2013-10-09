-- Resolution of simulation
NUM_POINTS = 50
-- Width of simulation
WIDTH = 400
-- Spring constant for forces applied by adjacent points
SPRING_CONSTANT = 0.005
-- Sprint constant for force applied to baseline
SPRING_CONSTANT_BASELINE = 0.005
-- Vertical draw offset of simulation
Y_OFFSET = 300
-- Damping to apply to speed changes
DAMPING = 0.98
-- Number of iterations of point-influences-point to do on wave per step
-- (this makes the waves animate faster)
ITERATIONS = 5

-- Make points to go on the wave
function makeWavePoints(numPoints)
    local t = {}
    for n = 1,numPoints do
        -- This represents a point on the wave
        local newPoint = {
            x    = n / numPoints * WIDTH,
            y    = Y_OFFSET,
            spd = {y=0}, -- speed with vertical component zero
            mass = 1
        }
        t[n] = newPoint
    end
    return t
end

-- A phase difference to apply to each sine
offset = 0

NUM_BACKGROUND_WAVES = 7
BACKGROUND_WAVE_MAX_HEIGHT = 5
BACKGROUND_WAVE_COMPRESSION = 1/5

-- Amounts by which a particular sine is offset
sineOffsets = {}

-- Amounts by which a particular sine is amplified
sineAmplitudes = {}

-- Amounts by which a particular sine is stretched
sineStretches = {}

-- Amounts by which a particular sine's offset is multiplied
offsetStretches = {}

-- Set each sine's values to a reasonable random value
for i=1,NUM_BACKGROUND_WAVES do
    table.insert(sineOffsets, -1 + 2*math.random())
    table.insert(sineAmplitudes, math.random()*BACKGROUND_WAVE_MAX_HEIGHT)
    table.insert(sineStretches, math.random()*BACKGROUND_WAVE_COMPRESSION)
    table.insert(offsetStretches, math.random()*BACKGROUND_WAVE_COMPRESSION)
end

-- This function sums together the sines generated above,
-- given an input value x
function overlapSines(x)
    local result = 0
    for i=1,NUM_BACKGROUND_WAVES do
        result = result
            + sineOffsets[i]
            + sineAmplitudes[i] * math.sin(
                x * sineStretches[i] + offset * offsetStretches[i])
    end
    return result
end

wavePoints = makeWavePoints(NUM_POINTS)

-- Update the positions of each wave point
function updateWavePoints(points, dt)
    for i=1,ITERATIONS do
        for n,p in ipairs(points) do
            -- force to apply to this point
            local force = 0

            -- forces caused by the point immediately to the left or the right
            local forceFromLeft, forceFromRight

            if n == 1 then -- wrap to left-to-right
                local dy = points[# points].y - p.y
                forceFromLeft = SPRING_CONSTANT * dy
            else -- normally
                local dy = points[n-1].y - p.y
                forceFromLeft = SPRING_CONSTANT * dy
            end
            if n == # points then -- wrap to right-to-left
                local dy = points[1].y - p.y
                forceFromRight = SPRING_CONSTANT * dy
            else -- normally
                local dy = points[n+1].y - p.y
                forceFromRight = SPRING_CONSTANT * dy
            end

            -- Also apply force toward the baseline
            local dy = Y_OFFSET - p.y
            forceToBaseline = SPRING_CONSTANT_BASELINE * dy

            -- Sum up forces
            force = force + forceFromLeft
            force = force + forceFromRight
            force = force + forceToBaseline

            -- Calculate acceleration
            local acceleration = force / p.mass

            -- Apply acceleration (with damping)
            p.spd.y = DAMPING * p.spd.y + acceleration

            -- Apply speed
            p.y = p.y + p.spd.y
        end
    end
end

-- Callback when updating
function love.update(dt)
    if love.keyboard.isDown"k" then
        offset = offset + 1
    end

    -- On click: Pick nearest point to mouse position
    if love.mouse.isDown("l") then
        local mouseX, mouseY = love.mouse.getPosition()
        local closestPoint = nil
        local closestDistance = nil
        for _,p in ipairs(wavePoints) do
            local distance = math.abs(mouseX-p.x)
            if closestDistance == nil then
                closestPoint = p
                closestDistance = distance
            else
                if distance <= closestDistance then
                    closestPoint = p
                    closestDistance = distance
                end
            end
        end

        closestPoint.y = love.mouse.getY()
    end

    -- Update positions of points
    updateWavePoints(wavePoints, dt)
end

local circle = love.graphics.circle
local line   = love.graphics.line
local color  = love.graphics.setColor
love.graphics.setBackgroundColor(0xff,0xff,0xff)

-- Callback for drawing
function love.draw(dt)

    -- Draw baseline
    color(0xff,0x33,0x33)
    line(0, Y_OFFSET, WIDTH, Y_OFFSET)

    -- Draw "drop line" from cursor

    local mouseX, mouseY = love.mouse.getPosition()
    line(mouseX, 0, mouseX, Y_OFFSET)
    -- Draw click indicator
    if love.mouse.isDown"l" then
        love.graphics.circle("line", mouseX, mouseY, 20)
    end

    -- Draw overlap wave animation indicator
    if love.keyboard.isDown "k" then
        love.graphics.print("Overlap waves PLAY", 10, Y_OFFSET+50)
    else
        love.graphics.print("Overlap waves PAUSED", 10, Y_OFFSET+50)
    end


    -- Draw points and line
    for n,p in ipairs(wavePoints) do
        -- Draw little grey circles for overlap waves
        color(0xaa,0xaa,0xbb)
        circle("line", p.x, Y_OFFSET + overlapSines(p.x), 2)
        -- Draw blue circles for final wave
        color(0x00,0x33,0xbb)
        circle("line", p.x, p.y + overlapSines(p.x), 4)
        -- Draw lines between circles
        if n == 1 then
        else
            local leftPoint = wavePoints[n-1]
            line(leftPoint.x, leftPoint.y + overlapSines(leftPoint.x), p.x, p.y + overlapSines(p.x))
        end
    end
end