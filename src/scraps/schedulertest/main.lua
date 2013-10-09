require 'core.oldentity.shapes'
require 'core.oldentity.camera'
require 'core.oldentity.group'
require 'core.input'

require 'game.tween'
Easing = require 'external.easing'

require 'core.scheduler'

DEBUG = true

function love.load()
    -- initialize library


    circle = CollidableCircle(100, 100, 50)
    circle:setColor(205,147,176)

    rectangle = CollidableRectangle(350, 250, 100, 100)
    rectangle:setColor(205,147,147)

    rectangle2 = CollidableRectangle(550, 450, 100, 100)
    rectangle2:setColor(205,147,147)

    point = CollidablePoint(500, 100)
    point:setColor(147,147,205)

    bigcircle = CollidableCircle(300, 300, 300)
    bigcircle:setColor(147,147,205)

    shape_collection = Group()
    shape_collection:add(circle)
    shape_collection:add(rectangle)
    shape_collection:add(rectangle2)
    shape_collection:add(point)
    shape_collection:add(bigcircle)


    camera = Camera(0, 0)

  

    scheduler = Scheduler()

    local prev_x, prev_y = camera.position.x, camera.position.y

    intensity = 30

    jitter = function()
        camera:move(math.random(-intensity, intensity), math.random(-intensity, intensity))
    end

    scheduler:do_for(5, 
        jitter,
        function()
            Tweener:addTween(1, camera.position, {x = prev_x, y = prev_y}, Easing.linear)
        end
    )

    dd = 0
    display_debug = function()
        dd = dd + 1
    end

    dd2 = 0
    display_debug2 = function()
        dd2 = dd2 + 1
    end

    scheduler:do_after(5, 
        function()
            scheduler:do_for(4, display_debug) 
        end
    )

    scheduler:do_every(1, 
        function()
            scheduler:do_for(0.5, display_debug2) 
        end
    )




    time = 0
end

function love.update(dt)
  
    time = time + dt
    scheduler:update(dt)
    Tweener:update(dt)

end

function love.draw()

    love.graphics.setBackgroundColor(63, 63, 63, 255)

    camera:draw(shape_collection)

    if DEBUG then

        debugstart = 200
        love.graphics.print("Camera x: " .. camera.position.x, 50, debugstart + 20)
        love.graphics.print("Camera y: " .. camera.position.y, 50, debugstart + 40)
        love.graphics.print("Time: " .. time, 50, debugstart + 60)
        love.graphics.print("dd: " .. dd, 50, debugstart + 80)
        love.graphics.print("dd2: " .. dd2, 50, debugstart + 100)

    end


end