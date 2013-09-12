
require 'core.tween'
Easing = require 'external.easing'

function love.load()

    initial = 0
    ultimate = 10

    linear_five = Tween(0, 10, 5, Easing.linear)
    linear_ten = Tween(0, 10, 10, Easing.linear)

    time = 0

end

function love.update(dt)

    time = time + dt

    linear_five:update(dt)
    linear_ten:update(dt)


end

function love.draw()

    love.graphics.setBackgroundColor(63, 63, 63, 255)

    debugstart = 200
    love.graphics.print("Total Time: " .. time, 50, debugstart + 20)
    love.graphics.print("Linear Tween over 5 Seconds:  " .. linear_five.value, 50, debugstart + 40)
    love.graphics.print("Linear Tween over 10 Seconds: " .. linear_ten.value, 50, debugstart + 60)

end