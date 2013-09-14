require 'core.components.transform'
require 'core.components.rendering'
require 'core.systems.renderingsystem'
require 'core.shapedata'
Timer = require 'external.timer'


function love.load()


    rendering_system = RenderingSystem()

    circle_transform = Transform(100, 100)
    circle_rendering = Rendering():setColor(205,147,176):setShape(CircleShape:new(50))

    rectangle_transform = Transform(300, 100)
    rectangle_rendering = Rendering():setColor(205,147,147):setShape(RectangleShape:new(100, 50))

    point_transform = Transform(500, 100)
    point_rendering = Rendering():setColor(147,147,205):setShape(PointShape:new())

    mouse_transform = Transform(100, 100)
    mouse_rendering = Rendering():setColor(147,176,205):setShape(CircleShape:new(50))

    periodic = 1

    mouse_transform:moveTo(love.mouse.getPosition())

    input_disabled = false


end

function love.update(dt)

    Timer.update(dt)

   if love.keyboard.isDown(" ") then

     if not input_disabled then

            periodic = periodic + 1
           
            if periodic > 3 then
                periodic = 1
            end

            if periodic == 1 then
                mouse_rendering:setShape(CircleShape:new(50))
            elseif periodic == 2 then
                mouse_rendering:setShape(RectangleShape:new(100, 50))
            elseif periodic == 3 then
                mouse_rendering:setShape(PointShape:new())
            end

            input_disabled = true

            Timer.add(0.2, function() input_disabled = false end)

       end
    end


    mouse_transform:moveTo(love.mouse.getPosition())

  

end

function love.draw()

    love.graphics.setBackgroundColor(63, 63, 63, 255)

    rendering_system:draw(circle_transform, circle_rendering)
    rendering_system:draw(rectangle_transform, rectangle_rendering)
    rendering_system:draw(point_transform, point_rendering)

    rendering_system:draw(mouse_transform, mouse_rendering)

end