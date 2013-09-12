
require 'core.tween'
require 'core.entity.shapes'
Easing = require 'external.easing'

function love.load()

    initial = 0
    ultimate = 10

--[[
    linear_five = Tween(0, 10, 5, Easing.linear)
    linear_ten = Tween(0, 10, 10, Easing.linear)

    bounce_five = Tween(0, 10, 5, Easing.inBounce)
    bounce_ten = Tween(0, 10, 10, Easing.inBounce)
--]] 

    
    rectangle = RectangleShape(0, 0, 100, 100)
    rectangle:setColor(205,147,147)

    Tweener:addTween(5, rectangle.position, {x = 300, y = 500}, Easing.outInElastic)

    time = 0

end

function love.update(dt)

    time = time + dt

    Tweener:update(dt)

end

function love.draw()

    love.graphics.setBackgroundColor(63, 63, 63, 255)

    rectangle:draw()

    debugstart = 200

    love.graphics.print("Total Time: " .. time, 50, debugstart + 20) 

end