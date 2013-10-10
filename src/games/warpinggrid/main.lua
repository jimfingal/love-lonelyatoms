require 'game.screenmap'
require 'collections.matrix'
require 'entity.systems.inputsystem'

require 'grid'

DEBUG = true


local frame = 0
local memsize = 0

function love.load()

    grid3d = Grid(love.graphics.getWidth(), love.graphics.getHeight(), 30, 30)

    mouse_x = 0
    mouse_y = 0

    input_system = InputSystem()
    input_system:registerInput(' ', "implosive")
end


-- Perform computations, etc. between screen refreshes.
function love.update(dt)

    input_system:update(dt)

    mouse_x, mouse_y = love.mouse.getPosition()

    last_mouse_x, last_mouse_y = mouse_x, mouse_y


    if input_system:heldAction("implosive") then
        grid3d:applyImplosiveForce(100, Vector3(mouse_x, mouse_y, -100), 200)
    end

    grid3d:update(dt)

end

function love.mousepressed(x, y, button)
    mouse_x, mouse_y = love.mouse.getPosition()

    grid3d:applyExplosiveForce(500, Vector3(mouse_x, mouse_y, -1), 80)
end

-- Update the screen.

function love.draw()


    love.graphics.setBackgroundColor(63, 63, 63, 255)

    love.graphics.setColor(147,147,205)

    love.graphics.setLineStyle("rough")
    grid3d:draw()


    if DEBUG then
       local debugstart = 50
        love.graphics.setColor(255, 255, 255)
        love.graphics.print("FPS: " .. love.timer.getFPS(), 50, debugstart + 20)
        love.graphics.print("Mouse X: " .. tostring(mouse_x), 50, debugstart + 40)
        love.graphics.print("Mouse Y: " .. tostring(mouse_y), 50, debugstart + 60)

        frame = frame + 1

        if frame % 10 == 0 then
            memsize = collectgarbage('count')
        end

        love.graphics.print('Memory actually used (in kB): ' .. memsize, 10, debugstart + 320)
        love.graphics.print('Vector3 objects created: ' .. ClassCounter[Vector3], 10, debugstart + 340)
        love.graphics.print('Vector2 objects created: ' .. ClassCounter[Vector2], 10, debugstart + 360)

    end

end
