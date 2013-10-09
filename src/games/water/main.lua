require 'entity.world'
require 'entity.systems.inputsystem'
require 'entity.systems.particlesystem'

require 'external.middleclass'

require 'util.counters'

require 'game.screenmap'
require 'collections.linkedlist'
require 'waterparticle'

Easing = require 'external.easing'

Actions = {}

Actions.AGITATE = "agitate"

DEBUG = true

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

    local left_particle = nil
    for x = 0, love.graphics.getWidth(), 10 do

        local particle = particle_system:getParticle(WaterParticle, x, 300, 0, 0)

        if left_particle then particle.left = left_particle end

        particle_list:append(particle)

        left_particle = particle


    end

end



-- Perform computations, etc. between screen refreshes.
function love.update(dt)

    --[[
    local particle_system =  world:getSystem(ParticleSystem)
    particle_system:updateParticles(dt)
    ]]

    WaterParticle.updateParticles(particle_list, dt)

end




function love.mousepressed(x, y, button)


    local mouseX, mouseY = love.mouse.getPosition()
    local closest_node = nil
    local closest_distance = nil

    for _, node in particle_list:members() do
    
        local distance = math.abs(mouseX - node:getValue().x)
    
        if closest_distance == nil then
            closest_node = node
            closest_distance = distance
        else
            if distance <= closest_distance then
                closest_node = node
                closest_distance = distance
            end
        end
    end

    closest_node:getValue().y = love.mouse.getY()

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

