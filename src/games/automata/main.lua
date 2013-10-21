require 'entity.systems.inputsystem'
require 'entity.systems.schedulesystem'
require 'entity.systems.timesystem'
require 'entity.world'
require 'entity.entityquery'

require 'external.middleclass'

require 'util.counters'

require 'game.screenmap'
require 'collections.matrix'

require 'game.automata.life'

require 'game.generic.genericbehaviors'


DRAWABLE_ENTITIES = EntityQuery():addOrSet(Rendering):addOrSet(Transform)

DEBUG = false

frame = 1
memsize = 0

local world = nil

function love.load()

    world = World()

    local input_system = InputSystem()
    input_system:registerInput(' ', "pause")
    input_system:registerInput('r', "reset")
    world:setSystem(input_system)

    local schedule_system = ScheduleSystem()
    world:setSystem(schedule_system)

    local time_system = TimeSystem()
    time_system:stop()    
    world:setSystem(time_system)

    local tween_system = TweenSystem(world)
    world:setSystem(tween_system)

    local rendering_system = RenderingSystem()
    world:setSystem(rendering_system)

    local xtiles = 50
    local ytiles = 50

    screen_map = ScreenMap(love.graphics.getWidth(), love.graphics.getHeight(), xtiles, ytiles)

    mouse_x = 0
    mouse_y = 0

    time_interval = 0.1

    schedule_system:doEvery(time_interval, processAutomata)

    life_grid = LifeGrid(xtiles, ytiles)


    local instructions = world:getEntityManager():createEntity('instructions')
    instructions:addComponent(Transform(25, 100))
    local rendering = TextRendering("Press Space Bar to Pause, 'R' to reset"):setColor(255, 255, 255, 0)
    instructions:addComponent(Rendering():addRenderable(rendering))

    GenericBehaviors.fadeTextInAndOut(instructions, 2, 5, 2)

end


function processAutomata()
    life_grid:updateFrame()
end


-- Perform computations, etc. between screen refreshes.
function love.update(dt)

    local time_system = world:getTimeSystem()

    time_system:update(dt)

    local input_system = world:getInputSystem()

    input_system:update(dt)
    
    if input_system:newAction("pause") then
        time_system:switch()
    end

    if input_system:newAction("reset") then
        life_grid:init()
    end

    world:getScheduleSystem():update(time_system:getDt())
    world:getTweenSystem():update(dt)


end




function love.mousepressed(x, y, button)
    local mouse_x, mouse_y = love.mouse.getPosition()
    local tile_hover = screen_map:getCoordinates(mouse_x, mouse_y)
    local x, y = tile_hover:unpack()
    local current = life_grid:getCell(x, y)
    current:invertState()
end



-- Update the screen.

function love.draw()


    love.graphics.setBackgroundColor(63, 63, 63, 255)

    drawCellularAutomata(screen_map)

    local drawables = world:getEntityManager():query(DRAWABLE_ENTITIES)
    world:getRenderingSystem():renderDrawables(drawables)


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

            --[[ Draw Grid lines
            if x == 0 and y > 0 then
                love.graphics.setColor(200,200,200, 100)
                love.graphics.line(0, ytile, love.graphics.getWidth(), ytile)
            end

            if y == 0 and x > 0 then
                love.graphics.setColor(200,200,200, 100)
                love.graphics.line(xtile, 0, xtile, love.graphics.getHeight())
            end
            --]]

            -- Draw color

            g = g + 10

            local x1 = x + 1
            local y1 = y + 1

            local current = life_grid:getCell(x1, y1)

            if current:getState() == true then 
                love.graphics.setColor(r,g,b, 255)
                love.graphics.rectangle("fill", xtile, ytile, screen_map.tile_width, screen_map.tile_height)

            else
                --
            end

        end
    end


end

