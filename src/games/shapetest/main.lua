require 'core.entity.shapes'
require 'core.mixins.collidable'

require 'collections.list'
Timer = require 'external.timer'
require 'external.middleclass'

function love.load()
    -- initialize library

    circle = CollidableCircle(100, 100, 50)
    circle:setColor(205,147,176)

    rectangle = CollidableRectangle(300, 100, 100, 50)
    rectangle:setColor(205,147,147)

    point = CollidablePoint(500, 100)
    point:setColor(147,147,205)


    mouse_shapes = List()

    mc = CollidableCircle(300, 300, 50)
    mr = CollidableRectangle(300, 100, 50, 25)
    mp = CollidablePoint(500, 100)

    mc:setColor(147,176,205)
    mr:setColor(147,176,205)
    mp:setColor(147,176,205)

    mouse_shapes:append(mc)
    mouse_shapes:append(mr)
    mouse_shapes:append(mp)

    periodic = 1

    mouse = mouse_shapes:memberAt(periodic)

    mouse:moveTo(love.mouse.getPosition())

    input_disabled = false


end

function love.update(dt)

   if love.keyboard.isDown(" ") then

     if not input_disabled then

            periodic = periodic + 1
           
            if periodic > 3 then
                periodic = 1
            end

            mouse = mouse_shapes:memberAt(periodic)

            input_disabled = true

            Timer.add(0.2, function() input_disabled = false end)

       end
    end


    --[[
       -- rotate rectangle
        rect:rotate(dt)

        -- check for collisions
        Collider:update(dt)

        while #text > 40 do
            table.remove(text, 1)
        end
    ]]--
    -- move circle to mouse position

    mouse:moveTo(love.mouse.getPosition())

    Timer.update(dt)

end

function love.draw()

    love.graphics.setBackgroundColor(63, 63, 63, 255)


     if (mouse:collidesWith(point)) then

        if instanceOf(PointShape, mouse) then
            love.graphics.setBackgroundColor(50, 50, 50, 255)
        end
        
        mouse:setFillMode('line')
        mouse:draw()
        mouse:setFillMode('fill')
    else
        mouse:draw()
    end

    if (circle:collidesWith(mouse)) then
        circle:setFillMode('line')
        circle:draw()
        circle:setFillMode('fill')
    else
        circle:draw()
    end


    if (rectangle:collidesWith(mouse)) then
        rectangle:setFillMode('line')
        rectangle:draw()
        rectangle:setFillMode('fill')
    else
        rectangle:draw()
    end

    point:draw()


end