require 'core.entity.world'
require 'core.systems.inputsystem'
require 'core.systems.particlesystem'

require 'external.middleclass'

require 'utils.counters'

require 'spatial.screenmap'
require 'collections.linkedlist'
require 'waterparticle'

Easing = require 'external.easing'

Actions = {}

Actions.AGITATE = "agitate"

DEBUG = false

frame = 1
memsize = 0

function love.load()


    world = World()

    input_system = InputSystem()

    input_system:registerInput('up', Actions.CHANGE_WAVE_UP)
    input_system:registerInput('down', Actions.CHANGE_WAVE_DOWN)
    input_system:registerInput('w', Actions.CHANGE_NOTE_UP)
    input_system:registerInput('s', Actions.CHANGE_NOTE_DOWN)
    input_system:registerInput(' ', "reset")

    world:setSystem(input_system)
        
    local particle_system = ParticleSystem()
    world:setSystem(particle_system)
    
    particle_system:addParticleType(WaterParticle(world), 2000)

    particle_list = LinkedList()

    for x = 0, love.graphics.getWidth(), 3 do
        local particle = particle_system:getParticle(WaterParticle, x, 300, 0, -250)
        particle_list:append(particle)
    end

end



-- Perform computations, etc. between screen refreshes.
function love.update(dt)

    local particle_system =  world:getSystem(ParticleSystem)
    particle_system:updateParticles(dt)

end




function love.mousepressed(x, y, button)
 
end



-- Update the screen.

function love.draw()


    love.graphics.setBackgroundColor(63, 63, 63, 255)

    local particle_system =  world:getSystem(ParticleSystem)
    particle_system:drawParticles()



    if DEBUG then
       local debugstart = 50
        love.graphics.setColor(255, 255, 255)
        love.graphics.print("FPS: " .. love.timer.getFPS(), 50, debugstart + 20)

        frame = frame + 1

        if frame % 10 == 0 then
            memsize = collectgarbage('count')
        end

        love.graphics.print('Memory actually used (in kB): ' .. memsize, 10, debugstart + 320)
    end

end

