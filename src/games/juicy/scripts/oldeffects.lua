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

EffectDispatcher = class("EffectsDispatcher")

function EffectDispatcher:initialize(world)

    self.world = world
    self.tween_system = world:getSystem(TweenSystem)
    self.schedule_system = world:getSystem(ScheduleSystem)

end


function EffectDispatcher:dropInBricks()

    local bricks = self.world:getEntitiesInGroup(Tags.BRICK_GROUP)

    -- Send bricks up to sky and make them smaller


    local vertical_translation = Vector(0, -300)

    for brick in bricks:members() do

        local transform = brick:getComponent(Transform)
        local shape = brick:getComponent(ShapeRendering):getShape()

        local oldx = transform:getPosition().x
        local oldy = transform:getPosition().y

        local new_position = transform:getPosition() + vertical_translation
        transform:moveTo(new_position:unpack())


        local rotate_tween = 1
        local drop_tween = 1
        local scale_tween = 1

        if Settings.BRICKS_JITTER then
            rotate_tween = 1 + math.random()
            drop_tween = 1 + math.random()
            scale_tween = 1 + math.random()

        end

        self.tween_system:addTween(drop_tween, brick:getComponent(Transform):getPosition(), {x = oldx, y = oldy}, Easing.outBounce)

        if Settings.BRICKS_ROTATE then
            self.tween_system:addTween(rotate_tween, brick:getComponent(Transform), {rotation = 2 * math.pi }, Easing.outBounce)
        end

        if Settings.BRICKS_SCALEIN then

            shape.width = 30
            shape.height = 10
            self.tween_system:addTween(scale_tween, brick:getComponent(ShapeRendering):getShape(), {width = 50, height = 20}, Easing.outBounce)

        end

    end

  
end


function EffectDispatcher:dropInPlayer()

    local player = self.world:getTaggedEntity(Tags.PLAYER)

    -- Send player up to sky and make them smaller

    local vertical_translation = Vector(0, -300)
    local transform = player:getComponent(Transform)
    local shape = player:getComponent(ShapeRendering):getShape()

    local new_position = transform:getPosition() + vertical_translation
    transform:moveTo(new_position:unpack())

    local rotate_tween = 1
    local drop_tween = 1
    local scale_tween = 1

    if Settings.PLAYER_JITTER then
        rotate_tween = 1 + math.random()
        drop_tween = 1 + math.random()
        scale_tween = 1 + math.random()

    end


    self.tween_system:addTween(drop_tween, player:getComponent(Transform):getPosition(), {x = 350, y = 500}, Easing.outBounce)

    if Settings.PLAYER_ROTATE then
        self.tween_system:addTween(rotate_tween, player:getComponent(Transform), {rotation = 2 * math.pi }, Easing.outBounce)
    end

    if Settings.PLAYER_SCALEIN then
        shape.width = 50
        shape.height = 15
        self.tween_system:addTween(scale_tween, player:getComponent(ShapeRendering):getShape(), {width = 100, height = 30}, Easing.outBounce)
    end


end


function EffectDispatcher.cameraShake()
        
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

function EffectDispatcher.scaleEntity(entity, dx, dy)

    local revert = 
        function()
            world:getSystem(TweenSystem):addTween(0.1, 
                entity:getComponent(Transform):getScale(), 
                {x = 1, y = 1 }, 
                Easing.linear)
        end

    local scaleUp = function()
                world:getSystem(TweenSystem):addTween(0.1, 
                    entity:getComponent(Transform):getScale(), 
                    {x = dx, y = dy }, 
                    Easing.inSine, 
                    revert)
        end

    scaleUp()
end

function EffectDispatcher.rotateEntity(entity)

    local transform = entity:getComponent(Transform)
    local current_rotation = transform:getRotation()

    local target_rotation = 0

    if current_rotation < math.pi then
        target_rotation = 2 * math.pi
    end

    world:getSystem(TweenSystem):addTween(0.1, transform, {rotation = target_rotation }, Easing.linear)

end


--[[
function EffectDispatcher.rotateJitter(entity, intensity)

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

function EffectDispatcher.allEffects(entity, dx, dy) 
    EffectDispatcher.scaleEntity(entity, dx, dy) 
    EffectDispatcher.rotateEntity(entity) 
end


function EffectDispatcher.slowMo(length)

    local time_system = world:getSystem(TimeSystem)

    time_system.dilation = 0.1

    world:getSystem(TweenSystem):addTween(length, time_system, {dilation = 1 }, Easing.outQuad)

end


function EffectDispatcher.dispatchBrick(ball, brick)

    local ball_position = ball:getComponent(Transform):getPosition()
    local ball_movement = ball:getComponent(Motion)
    local ball_collider = ball:getComponent(Collider)
    local ball_rendering = ball:getComponent(ShapeRendering)

    local brick_transform = brick:getComponent(Transform)
    local brick_position = brick:getComponent(Transform):getPosition()
    local brick_collider = brick:getComponent(Collider)
    local brick_rendering = brick:getComponent(ShapeRendering)

    brick_collider:disable()
    
    -- death animation

    local tween_system = brick:getWorld():getSystem(TweenSystem)

    brick_transform:setLayerOrder(brick_transform:getLayerOrder() + 1)
    tween_system:addTween(1 + math.random(), brick_transform, {rotation = 8 * math.pi}, Easing.linear)
    tween_system:addTween(1 + math.random(), brick_rendering:getShape(), {width = 0, height = 0}, Easing.linear)
    tween_system:addTween(1+ math.random(), brick_rendering.color, {alpha = 0}, Easing.linear)


    local normalized_ball_velocity = ball_movement:getVelocity():normalized()

    local brick_target_x = brick_position.x + 300 * normalized_ball_velocity.x
    local brick_target_y = brick_position.y + 300 * normalized_ball_velocity.y

    tween_system:addTween(1 + math.random(), brick_position, {x = brick_target_x, y =brick_target_y}, Easing.linear)


end

function EffectDispatcher.playBrickSoundWithAdjustedPitch(brick, dt)

    local sound_component = brick:getComponent(SoundComponent)
    local retrieved_sound = sound_component:getSound(Assets.BRICK_SOUND)

    if dt < 0.5 then
        local current_pitch = retrieved_sound:getPitch()
        retrieved_sound:setPitch(current_pitch + (1/8))
    else
        retrieved_sound:setPitch(1.0)
    end

    love.audio.play(retrieved_sound)
end



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


return EffectDispatcher