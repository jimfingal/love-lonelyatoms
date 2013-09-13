require 'core.oldentity.shapes'
require 'core.oldentity.camera'
require 'core.oldentity.group'
require 'core.input'

-- Actions
Actions = {}

Actions.LEFT = "left"
Actions.RIGHT = "right" 
Actions.UP = "up" 
Actions.DOWN = "down" 

Actions.ROTATE_LEFT = "rotateleft" 
Actions.ROTATE_RIGHT = "rotateright" 

Actions.SCALE_UP = "scaleup"
Actions.SCALE_DOWN = "scaledown"


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

    input = InputManager()
    input:registerInput('a', Actions.LEFT)
    input:registerInput('d', Actions.RIGHT)
    input:registerInput('w', Actions.UP)
    input:registerInput('s', Actions.DOWN)
    --input:registerInput('left', Actions.ROTATE_LEFT)
    --input:registerInput('right', Actions.ROTATE_RIGHT)
    input:registerInput('up', Actions.SCALE_UP)
    input:registerInput('down', Actions.SCALE_DOWN)

    move_speed = 100
    scale_speed = 2
    rotate_speed = 1

end

function love.update(dt)

    input:update(dt)

    if input:heldAction(Actions.LEFT) then
        camera:move(-dt * move_speed, 0)
    end

    if input:heldAction(Actions.RIGHT) then
        camera:move(dt * move_speed, 0)
    end

    if input:heldAction(Actions.UP) then
        camera:move(0, -dt * move_speed)
    end

    if input:heldAction(Actions.DOWN) then
        camera:move(0, dt * move_speed)
    end

    if input:heldAction(Actions.SCALE_UP) then
        camera:addScale(dt * scale_speed)
    end

    if input:heldAction(Actions.SCALE_DOWN) then
        camera:addScale(-dt * scale_speed)
    end

    --[[
    if input:heldAction(Actions.ROTATE_LEFT) then
        camera:rotate(dt * scale_speed)
    end

    if input:heldAction(Actions.ROTATE_RIGHT) then
        camera:rotate(-dt * scale_speed)
    end
    --]]

end

function love.draw()

    love.graphics.setBackgroundColor(63, 63, 63, 255)

    camera:draw(shape_collection)

    if DEBUG then

        debugstart = 200
        love.graphics.print("Camera x: " .. camera.position.x, 50, debugstart + 20)
        love.graphics.print("Camera y: " .. camera.position.y, 50, debugstart + 40)
        love.graphics.print("Camera scale: " .. camera.s.x, 50, debugstart + 60)
        -- love.graphics.print("Camera rotation: " .. camera.rotation, 50, debugstart + 80)


    end



end