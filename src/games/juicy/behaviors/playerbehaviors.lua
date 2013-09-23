require 'core.components.transform'
require 'core.components.rendering'
require 'core.components.collider'
require 'core.components.motion'
Easing = require 'external.easing'

require 'enums.tags'
require 'enums.events'




function collidePlayerWithWall(player, wall)

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

        local new_x = wall_position.x + wall_hitbox.width + 1

        player_transform:moveTo(new_x, player_transform:getPosition().y)
        player_movement.velocity = -player_movement.velocity / 2

    elseif wall == right_wall then

        local new_x = wall_position.x - player_collider:hitbox().width - 1

        player_transform:moveTo(new_x, player_transform:getPosition().y)
        player_movement.velocity = -player_movement.velocity / 2

    else 

        assert(false, "Collided but didn't detect right or left edge collision... " .. tostring(player) .. "; " .. tostring(wall))

    end

end

