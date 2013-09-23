require 'core.components.transform'
require 'core.components.rendering'
require 'core.components.collider'
require 'core.components.motion'
require 'core.systems.tweensystem'
require 'core.systems.schedulesystem'

require 'core.vector'

require 'enums.scenes'
require 'enums.tags'

require "settings"

require 'math'

GlobalEffects = {}

function GlobalEffects.cameraShake(world)
        
    local camera = world:getSystem(CameraSystem)
    local schedule_system = world:getSystem(ScheduleSystem)
    local tween_system = world:getSystem(TweenSystem)

    intensity = 3

    local jitter = function()
        camera.transform:move(math.random(-intensity, intensity), math.random(-intensity, intensity))
    end

    schedule_system:doFor(0.3, 
        jitter,
        function()
            tween_system:addTween(0.1, camera.transform:getPosition(), {x = 0, y = 0}, Easing.linear)
        end
    )

end

function GlobalEffects.slowMo(world, length)

    local time_system = world:getSystem(TimeSystem)

    time_system.dilation = 0.1

    world:getSystem(TweenSystem):addTween(length, time_system, {dilation = 1 }, Easing.outQuad)

end

return GlobalEffects
