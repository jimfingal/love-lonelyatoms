require 'core.sprite'
require 'core.shapes'

require 'collections.list'
Timer = require 'external.timer'
require 'external.middleclass'

function love.load()
    -- initialize library

    cs = CircleShape(50)
    circle = Sprite(100, 100, cs)
    circle:setColor(205,147,176)


    rs = RectangleShape(100, 50)
    rectangle = Sprite(300, 100, rs)
    rectangle:setColor(205,147,147)


    ps = PointShape()
    point = Sprite(500, 100, ps)
    point:setColor(147,147,205)




    mouse_shapes = List()

    mcs = CircleShape(50)
    mc = Sprite(300, 300, mcs)

    mrs = RectangleShape(50, 25)
    mr = Sprite(300, 100, mrs)

    mps = PointShape()
    mp = Sprite(500, 100, mps)


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

        if instanceOf(PointShape, mouse.hitbox) then
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