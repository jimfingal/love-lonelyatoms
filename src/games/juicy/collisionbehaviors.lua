require 'core.components.transform'
require 'core.components.rendering'
require 'core.components.collider'
require 'core.components.motion'
Easing = require 'external.easing'

require 'enums.tags'
require 'enums.events'


function collideBallWithPaddle(ball, paddle)

	ball:getComponent(Messaging):emitMessage(Events.BALL_COLLISION_PLAYER, ball, paddle)

	local ball_transform = ball:getComponent(Transform)
    local ball_movement = ball:getComponent(Motion)
    local ball_hitbox = ball:getComponent(Collider):hitbox()

    local paddle_transform = paddle:getComponent(Transform)
    local paddle_hitbox = paddle:getComponent(Collider):hitbox()

	local new_y = paddle_transform:getPosition().y - ball_hitbox.height

	ball_transform:moveTo(ball_transform.position.x, new_y)


	-- Compare X with paddle x

	local paddle_origin = paddle_transform:getPosition().x
	local paddle_width = paddle_hitbox.width
	local third_of_paddle = paddle_hitbox.width / 3

	local middle_ball = ball_transform:getPosition().x + ball_hitbox.width/2

	local first_third = paddle_origin + third_of_paddle
	local second_third = first_third + third_of_paddle
	local third_third = paddle_origin + paddle_width


	-- Magic Number
	local paddle_english = 100

	if middle_ball <= first_third then

		-- Reverse y direction and hit to left
		ball_movement.velocity.y = -ball_movement.velocity.y
		ball_movement.velocity.x = ball_movement.velocity.x - paddle_english

	elseif middle_ball > first_third and middle_ball < second_third then

		-- Reverse y direction
		ball_movement.velocity.y = -ball_movement.velocity.y

		-- Slow x direction down
		if ball_movement.velocity.x > 0 then

			ball_movement.velocity.x = ball_movement.velocity.x - paddle_english/2

		elseif ball_movement.velocity.x < 0 then

			ball_movement.velocity.x = ball_movement.velocity.x + paddle_english/2

		end

	elseif middle_ball > second_third then

		-- Reverse y direction and hit to right
		ball_movement.velocity.y = -ball_movement.velocity.y
		ball_movement.velocity.x = ball_movement.velocity.x + paddle_english

	end	

end



function collideBallWithWall(ball, wall)

	ball:getComponent(Messaging):emitMessage(Events.BALL_COLLISION_WALL, ball, wall)

	local ball_transform = ball:getComponent(Transform)
    local ball_movement = ball:getComponent(Motion)
    local ball_collider = ball:getComponent(Collider)
    local ball_rendering = ball:getComponent(ShapeRendering)

    local wall_position = wall:getComponent(Transform):getPosition()
    local wall_hitbox = wall:getComponent(Collider):hitbox()

    local world = ball:getWorld()

	-- Top wall
	if wall == world:getTaggedEntity(Tags.TOP_WALL) then

		ball_transform:moveTo(ball_transform:getPosition().x, wall_position.y + wall_hitbox.height)
		ball_movement:invertVerticalVelocity()

	-- Bottom wall
	elseif wall == world:getTaggedEntity(Tags.BOTTOM_WALL) then

		ball_collider:disable()
		ball_rendering:disable()

	-- Left wall
	elseif wall == world:getTaggedEntity(Tags.LEFT_WALL) then

		ball_transform:moveTo(wall_position.x + wall_hitbox.width + 1, ball_transform:getPosition().y)
		ball_movement:invertHorizontalVelocity()

	-- Right wall
	elseif wall == world:getTaggedEntity(Tags.RIGHT_WALL) then

		ball_transform:moveTo(wall_position.x - 1 - ball_collider:hitbox().width, ball_transform:getPosition().y)
		ball_movement:invertHorizontalVelocity()
	end

end


function collideBallWithBrick(ball, brick)

	ball:getComponent(Messaging):emitMessage(Events.BALL_COLLISION_BRICK, ball, brick)

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

    local sound_component = brick:getComponent(SoundComponent)

    local retrieved_sound = sound_component:getSound(Assets.BRICK_SOUND)
    love.audio.play(retrieved_sound)


	brick_transform:setLayerOrder(brick_transform:getLayerOrder() + 1)
	tween_system:addTween(1 + math.random(), brick_transform, {rotation = 8 * math.pi}, Easing.linear)
	tween_system:addTween(1 + math.random(), brick_rendering:getShape(), {width = 0, height = 0}, Easing.linear)
	tween_system:addTween(1+ math.random(), brick_rendering.color, {alpha = 0}, Easing.linear)


	local normalized_ball_velocity = ball_movement:getVelocity():normalized()

	local brick_target_x = brick_position.x + 300 * normalized_ball_velocity.x
	local brick_target_y = brick_position.y + 300 * normalized_ball_velocity.y

	tween_system:addTween(1 + math.random(), brick_position, {x = brick_target_x, y =brick_target_y}, Easing.linear)





	-- TODO handle bullet shit

	-- Colliding from the left or right
	if ball_position.x < brick_position.x or
	   ball_position.x > brick_position.x + brick_collider:hitbox().width then

		ball_movement:invertHorizontalVelocity()
	else
		ball_movement:invertVerticalVelocity()
	end

end

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

