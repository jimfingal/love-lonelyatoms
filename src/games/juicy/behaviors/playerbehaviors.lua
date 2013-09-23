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


    local player_left_edge = player_transform:getPosition().x
    local player_right_edge = player_transform:getPosition().x + player_collider:hitbox().width

    local wall_left_edge = wall_position.x
    local wall_right_edge = wall_position.x + wall_hitbox.width


    -- If something is immovable, then I could only collide with it in the direction I'm going

    -- Left Edge collision
    if player_left_edge <= wall_right_edge + 1 and player_right_edge >= wall_right_edge then

        -- Translate to be on the other side of it

        local new_x = wall_position.x + wall_hitbox.width + 1

        player_transform:moveTo(new_x, player_transform:getPosition().y)
        player_movement.velocity = -player_movement.velocity / 2

        --[[
        if self.current_action == Actions.PLAYER_LEFT then
            self.velocity = Vector.ZERO
        else
            self.velocity = -self.velocity
        end
        ]]


    elseif player_right_edge >= wall_left_edge - 1 and player_left_edge <= wall_left_edge  then

        local new_x = wall_position.x - player_collider:hitbox().width - 1

        -- Translate to be on the other side of it
        player_transform:moveTo(new_x, player_transform:getPosition().y)

        player_movement.velocity = -player_movement.velocity / 2

		--[[
        if self.current_action == Actions.PLAYER_RIGHT then
            self.velocity = Vector.ZERO
        else
            self.velocity = -self.velocity
        end
		]]

    else 

        assert(false, "Collided but didn't detect right or left edge collision... " .. tostring(player) .. "; " .. tostring(wall))

    end

end

