require 'collections.list'
require 'core.input'


messages = List()

SPACE = 'spaces'

keyboard = InputManager()


function love.load()


    keyboard:registerInput(' ', SPACE)

end

function love.update(dt)

    keyboard:update(dt)

    for action, _ in pairs(keyboard:newActions()) do
        messages:append("New Action: " .. action)
        if messages:size() > 25 then
            messages:popLeft()
        end
    end

    for action, t in pairs(keyboard:heldActions()) do
        messages:append("Held Action: " .. action .. " for " .. t)
        if messages:size() > 25 then
            messages:popLeft()
        end
    end


end

function love.draw()

     for i = 1, messages:size() do
        love.graphics.setColor(255,255,255, 255 - (i-1) * 6)
        love.graphics.print(messages:memberAt(i), 10, i * 15)
    end




end