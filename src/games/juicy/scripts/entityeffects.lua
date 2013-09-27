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

require 'utils.mathutils'


EntityEffects = {}

EntityEffects.glitchLock = {}

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

    local tweener = entity:getWorld():getSystem(TweenSystem)
    tweener:addTween(0.1, transform, {rotation = target_rotation }, Easing.linear)

end


function EntityEffects.glitchColors(entity)

    -- If this effect is already happening, the entity will end up getting reset
    -- to some other color
    if not EntityEffects.glitchLock[entity] then

        local rendering = entity:getComponent(ShapeRendering)

        local previous_color = rendering:getColor()

        local reset_color = function() 
            rendering:setColor(previous_color:unpack()) 
            EntityEffects.glitchLock[entity] = false
        end


        local schedule_system = entity:getWorld():getSystem(ScheduleSystem)
        
        schedule_system:doFor(0.3, 
            function()
                EntityEffects.glitchLock[entity] = true
                rendering:setColor(math.random(255), math.random(255), math.random(255))
            end,
            reset_color
        )

    end


end


function EntityEffects.emitConfetti(emitter, from_entity)

    local transform = from_entity:getComponent(Transform)
    local emitter_component = emitter:getComponent(Emitter)

    for x = 1, 5 do
        local e = emitter_component:emit(transform:getPosition().x, transform:getPosition().y, math.randomPlusOrMinus() * 200 * math.random(), -200 * math.random())
    end

end


return EntityEffects
