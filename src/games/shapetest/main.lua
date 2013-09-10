require 'engine.shapes'
require 'collections.list'
Timer = require 'external.timer'
require 'external.middleclass'

function love.load()
    -- initialize library

   
    circle = CircleShape(100, 100, 50)

    rectangle = RectangleShape(300, 100, 100, 50)

    point = PointShape(500, 100)


    mouse_shapes = List()

    cs = CircleShape(300, 300, 50)
    mouse_shapes:append(cs)

    ps = PointShape(500, 100)
    mouse_shapes:append(ps)

    rs = RectangleShape(300, 100, 100, 50)
    mouse_shapes:append(rs)

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

    love.graphics.setColor(147,176,205)

     if (mouse:collidesWith(point)) then

        if instanceOf(PointShape, mouse) then
            love.graphics.setBackgroundColor(50, 50, 50, 255)
        end
            
        mouse:draw()
    else
        mouse:draw('fill')
    end

    love.graphics.setColor(205,147,176)

    if (circle:collidesWith(mouse)) then
        circle:draw()
    else
        circle:draw('fill')
    end


    love.graphics.setColor(205,147,147)

    if (rectangle:collidesWith(mouse)) then
        rectangle:draw()
    else
        rectangle:draw('fill')
    end

    love.graphics.setColor(147,147,205)
    point:draw('fill')


end