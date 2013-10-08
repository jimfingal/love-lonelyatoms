require 'core.systems.inputsystem'
require 'core.systems.schedulesystem'
require 'core.systems.timesystem'

require 'external.middleclass'

require 'utils.counters'

require 'spatial.screenmap'
require 'collections.matrix'

require 'automata.life'

Actions = {}


DEBUG = false

frame = 1
memsize = 0

function love.load()


    input_system = InputSystem()
    input_system:registerInput(' ', "pause")
    input_system:registerInput('r', "reset")

    schedule_system = ScheduleSystem()

    time_system = TimeSystem()
    time_system:stop()

    local xtiles = 50
    local ytiles = 50

    screen_map = ScreenMap(love.graphics.getWidth(), love.graphics.getHeight(), xtiles, ytiles)

    mouse_x = 0
    mouse_y = 0

    time_interval = 0.1

    schedule_system:doEvery(time_interval, processAutomata)

    life_grid = LifeGrid(xtiles, ytiles)

end

function processAutomata()
    life_grid:updateFrame()
end


-- Perform computations, etc. between screen refreshes.
function love.update(dt)

    input_system:update(dt)
    time_system:update(dt)
    
    mouse_x, mouse_y = love.mouse.getPosition()
    tile_hover = screen_map:getCoordinates(mouse_x, mouse_y)

    if input_system:newAction("pause") then
        time_system:switch()
    end

    if input_system:newAction("reset") then
        life_grid:init()
    end

    schedule_system:update(time_system:getDt())


end




function love.mousepressed(x, y, button)
    mouse_x, mouse_y = love.mouse.getPosition()
    tile_hover = screen_map:getCoordinates(mouse_x, mouse_y)
    local x, y = tile_hover:unpack()
    local current = life_grid:getCell(x, y)
    current:invertState()
end



-- Update the screen.

function love.draw()


    love.graphics.setBackgroundColor(63, 63, 63, 255)

    drawCellularAutomata(screen_map)


    if DEBUG then
       local debugstart = 50
        love.graphics.setColor(255, 255, 255)
        love.graphics.print("FPS: " .. love.timer.getFPS(), 50, debugstart + 20)
        love.graphics.print("Frame: " .. life_grid:frameNumber(), 50, debugstart + 40)
        love.graphics.print("Time: " .. time_system:getTime(), 50, debugstart + 60)

        frame = frame + 1

        if frame % 10 == 0 then
            memsize = collectgarbage('count')
        end

        love.graphics.print('Memory actually used (in kB): ' .. memsize, 10, debugstart + 320)
    end

end


function drawCellularAutomata(screen_map)

    local r = 200
    local b = 40

    for x = 0, screen_map.xtiles - 1 do 

        local xtile = x * screen_map.tile_width
        r = r - 10
        b = b + 10
        local g = 50

        for y = 0, screen_map.ytiles - 1 do

            local ytile = y * screen_map.tile_height

            -- Draw Grid lines
            if x == 0 and y > 0 then
                love.graphics.setColor(200,200,200, 100)
                --love.graphics.line(0, ytile, love.graphics.getWidth(), ytile)
            end

            if y == 0 and x > 0 then
               love.graphics.setColor(200,200,200, 100)
                --love.graphics.line(xtile, 0, xtile, love.graphics.getHeight())
            end

            -- Draw color

            g = g + 10

            local x1 = x + 1
            local y1 = y + 1

            local current = life_grid:getCell(x1, y1)

            --assert(current, "Should be a cell at " .. tostring(x1) .. ", " .. tostring(y1) .. " but not for grid " .. tostring(cellular_grid))

            local mode = "line"

            if current:getState() == true then 
                love.graphics.setColor(r,g,b, 255)
                mode = "fill"
                love.graphics.rectangle(mode, xtile, ytile, screen_map.tile_width, screen_map.tile_height)

            else
                --
            end

            --love.graphics.rectangle(mode, x * screen_map.tile_width, y * screen_map.tile_height, screen_map.tile_width, screen_map.tile_height)
           
            -- love.graphics.setColor(200,200,200, 255)
            -- love.graphics.print(tostring(current), x * screen_map.tile_width, y * screen_map.tile_height)

        end
    end


end

