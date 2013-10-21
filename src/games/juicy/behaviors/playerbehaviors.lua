require 'entity.components.transform'
require 'entity.components.rendering'
require 'entity.components.collider'
require 'entity.components.motion'
Easing = require 'external.easing'

require 'enums.tags'
require 'enums.events'

PlayerBehaviors = {}

function PlayerBehaviors.collidePlayerWithWall(player, wall)

    local player_transform = player:getComponent(Transform)
    local player_movement = player:getComponent(Motion)
    local player_collider = player:getComponent(Collider)

    local wall_position = wall:getComponent(Transform):getPosition()
    local wall_hitbox = wall:getComponent(Collider):hitbox()

    local left_wall = wall:getWorld():getTaggedEntity(Tags.LEFT_WALL)
    local right_wall = wall:getWorld():getTaggedEntity(Tags.RIGHT_WALL)

    -- If something is immovable, then I could only collide with it in the direction I'm going

    -- Left Edge collision
    if wall == left_wall then

        local new_x = wall_position.x + wall_hitbox.width + 2

        player_transform:moveTo(new_x, player_transform:getPosition().y)
        player_movement.velocity = -player_movement.velocity / 2

    elseif wall == right_wall then

        local new_x = wall_position.x - player_collider:hitbox().width - 2

        player_transform:moveTo(new_x, player_transform:getPosition().y)
        player_movement.velocity = -player_movement.velocity / 2

    else 

        assert(false, "Collided but didn't detect right or left edge collision... " .. tostring(player) .. "; " .. tostring(wall))

    end

end

function PlayerBehaviors.dropInPlayer(world)

    local player = world:getTaggedEntity(Tags.PLAYER)
    local tween_system = world:getSystem(TweenSystem)

    -- Send player up to sky and make them smaller

    local transform = player:getComponent(Transform)
    local shape = player:getComponent(Rendering):getRenderable():getShape()

    transform:move(0, -300)

    local rotate_tween = 0.5
    local drop_tween = 0.5
    local scale_tween = 0.5

    if Settings.PLAYER_JITTER then
        rotate_tween = 0.5 + math.random()
        drop_tween = 0.5 + math.random()
        scale_tween = 0.5 + math.random()

    end

    tween_system:addTween(drop_tween, player:getComponent(Transform):getPosition(), {x = 350, y = 500}, Easing.outBounce)

    if Settings.PLAYER_ROTATE then
        tween_system:addTween(rotate_tween, player:getComponent(Transform), {rotation = 2 * math.pi }, Easing.outBounce)
    end

    if Settings.PLAYER_SCALEIN then
        shape.width = 50
        shape.height = 15
        tween_system:addTween(scale_tween, shape, {width = 100, height = 30}, Easing.outBounce)
    end

end


local speed_delta = Vector2(2300, 0)
local base_speed = Vector2(200, 0)

function PlayerBehaviors.playerInputResponse(player, held_actions, pressed_actions, dt)

    local player_movement = player:getComponent(Motion)

    if held_actions[Actions.PLAYER_RIGHT] then
    
        if player_movement.velocity.x < Vector2.ZERO.x then 
            player_movement.velocity.x = base_speed.x
        end

        player_movement.velocity.x = player_movement.velocity.x + (speed_delta.x * dt)

    
    elseif held_actions[Actions.PLAYER_LEFT] then
    
        if player_movement.velocity.x > Vector2.ZERO.x then 
            player_movement.velocity.x = -base_speed.x
        end

        player_movement.velocity.x = player_movement.velocity.x - (speed_delta.x * dt)

    end

end


return PlayerBehaviors

