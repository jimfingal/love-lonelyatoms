require 'core.components.transform'
require 'core.components.rendering'
require 'core.systems.renderingsystem'
require 'core.shapedata'


function love.load()


    rendering_system = RenderingSystem()

    circle_transform = Transform(100, 100)
    circle_rendering = Rendering():setColor(205,147,176):setShape(CircleShape:new(50))

    rectangle_transform = Transform(300, 100)
    rectangle_rendering = Rendering():setColor(205,147,147):setShape(RectangleShape:new(100, 50))

    point_transform = Transform(500, 100)
    point_rendering = Rendering():setColor(147,147,205):setShape(PointShape:new())

--[[
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
--]]

end

function love.update(dt)

end

function love.draw()

    love.graphics.setBackgroundColor(63, 63, 63, 255)

    rendering_system:draw(circle_transform, circle_rendering)
    rendering_system:draw(rectangle_transform, rectangle_rendering)
    rendering_system:draw(point_transform, point_rendering)

end