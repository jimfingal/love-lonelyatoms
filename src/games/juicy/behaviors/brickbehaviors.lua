require 'entity.components.transform'
require 'entity.components.rendering'
require 'entity.components.collider'
require 'entity.components.motion'
Easing = require 'external.easing'

require 'enums.tags'
require 'enums.events'


BrickBehaviors = {}


function BrickBehaviors.dropInBricks(world)

    local bricks = world:getEntitiesInGroup(Tags.BRICK_GROUP)
    local tween_system = world:getSystem(TweenSystem)
    -- Send bricks up to sky and make them smaller

    for brick in bricks:members() do

        local transform = brick:getComponent(Transform)
        local shape = brick:getComponent(Rendering):getRenderable():getShape()

        local oldx = transform:getPosition().x
        local oldy = transform:getPosition().y

        transform:move(0, -300)

        local rotate_tween = 1
        local drop_tween = 1
        local scale_tween = 1

        if Settings.BRICKS_JITTER then
            rotate_tween = 1 + math.random()
            drop_tween = 1 + math.random()
            scale_tween = 1 + math.random()

        end

        tween_system:addTween(drop_tween, brick:getComponent(Transform):getPosition(), {x = oldx, y = oldy}, Easing.outBounce)

        if Settings.BRICKS_ROTATE then
            tween_system:addTween(rotate_tween, brick:getComponent(Transform), {rotation = 2 * math.pi }, Easing.outBounce)
        end

        if Settings.BRICKS_SCALEIN then

            shape.width = 30
            shape.height = 10
            tween_system:addTween(scale_tween, shape, {width = 50, height = 20}, Easing.outBounce)

        end

    end

end




function  BrickBehaviors.dispatchBrick(ball, brick)

    local ball_position = ball:getComponent(Transform):getPosition()
    local ball_movement = ball:getComponent(Motion)
    local ball_collider = ball:getComponent(Collider)
    local ball_rendering = ball:getComponent(Rendering):getRenderable()

    local brick_transform = brick:getComponent(Transform)
    local brick_position = brick:getComponent(Transform):getPosition()
    local brick_collider = brick:getComponent(Collider)
    local brick_rendering = brick:getComponent(Rendering):getRenderable()

    
    local brick_state = brick:getComponent(StateComponent)
    brick_state:setState(Tags.BRICK_ALIVE, false)
    
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

function  BrickBehaviors.playBrickSoundWithAdjustedPitch(brick, dt)

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

return BrickBehaviors