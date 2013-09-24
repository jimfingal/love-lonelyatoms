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

EntityEffects = {}

function EntityEffects.scaleEntity(entity, dx, dy)

    local revert = 
        function()
            entity:getWorld():getSystem(TweenSystem):addTween(0.1, 
                entity:getComponent(Transform):getScale(), 
                {x = 1, y = 1 }, 
                Easing.linear)
        end

    local scaleUp = function()
                entity:getWorld():getSystem(TweenSystem):addTween(0.1, 
                    entity:getComponent(Transform):getScale(), 
                    {x = dx, y = dy }, 
                    Easing.inSine, 
                    revert)
        end

    scaleUp()
end

function EntityEffects.rotateEntity(entity)

    local transform = entity:getComponent(Transform)
    local current_rotation = transform:getRotation()

    local target_rotation = 0

    if current_rotation < math.pi then
        target_rotation = 2 * math.pi
    end

    entity:getWorld():getSystem(TweenSystem):addTween(0.1, transform, {rotation = target_rotation }, Easing.linear)

end


--[[
function EntityEffects.rotateJitter(entity, intensity)

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




return EntityEffects
