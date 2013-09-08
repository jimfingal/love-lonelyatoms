require 'engine.shapes'
require 'collections.list'

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
    -- mouse = RectangleShape(300, 100, 100, 50)
    mouse:moveTo(love.mouse.getPosition())

end

function love.update(dt)

    if love.keyboard.isDown(" ") then

        periodic = periodic + 1
       
        if periodic > 3 then
            periodic = 1
        end

        mouse = mouse_shapes:memberAt(periodic)
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

end

function love.draw()

    love.graphics.setBackgroundColor(63, 63, 63, 255)

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

    love.graphics.setColor(147,176,205)

     if (mouse:collidesWith(point)) then
        mouse:draw()
    else
        mouse:draw('fill')
    end

end