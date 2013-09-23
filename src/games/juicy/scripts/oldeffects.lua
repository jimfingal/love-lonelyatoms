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






--[[
function rotateJitter(entity, intensity)

    local transform = entity:getComponent(Transform)
    local current_rotation = transform:getRotation() + 0

    local rotate_jitter = function()
        transform:rotate(math.random(-intensity, intensity))
    end

    world:getSystem(ScheduleSystem):doFor(0.2, 
        rotate_jitter,
        function()
            world:getSystem(TweenSystem):addTween(0.1, transform, {rotation = current_rotation}, Easing.linear)
        end
    )

end
]]


--[[
function EffectDispatcher.cameraZoom(entity)

    local position = entity:getComponent(Transform):getPosition()

    local camera_system = world:getSystem(CameraSystem)

    local origin_x = position.x - love.graphics.getWidth( ) / 2
    local origin_y = position.y - love.graphics.getHeight( ) / 2

    local zoomOut = function() 
        world:getSystem(TweenSystem):addTween(0.4, camera_system.transform.position, {x = 0, y = 0  }, Easing.linear)
      --  world:getSystem(TweenSystem):addTween(0.1, camera_system.transform.scale, {x = 1, y = 1  }, Easing.linear, zoomOut)

    end

    local zoomIn = function(to)
        world:getSystem(TweenSystem):addTween(0.1, camera_system.transform.position, {x = origin_x, y = origin_y  }, Easing.linear, zoomOut)
        --world:getSystem(TweenSystem):addTween(0.1, camera_system.transform.scale, {x = 3, y = 3  }, Easing.linear, zoomOut)

    end

    zoomIn()
  

end
]]