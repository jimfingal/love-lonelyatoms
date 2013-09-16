require 'core.components.transform'
require 'core.components.rendering'
require 'core.components.collider'
require 'core.components.motion'


function collideBallWithPaddle(ball, paddle)

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

	local ball_transform = ball:getComponent(Transform)
    local ball_movement = ball:getComponent(Motion)
    local ball_collider = ball:getComponent(Collider)
    local ball_rendering = ball:getComponent(Rendering)

    local wall_position = wall:getComponent(Transform):getPosition()

	-- Top wall
	if ball_transform:getPosition().y < 5 then

		ball_transform:moveTo(ball_transform:getPosition().x, 1)
		ball_movement:invertVerticalVelocity()

	-- Bottom wall

	elseif ball_transform:getPosition().y >= love.graphics.getHeight() - ball_collider:hitbox().height - 1 then

		-- TODO: easier way to just totally disable an entity
		ball_collider:disable()
		ball_rendering:disable()

	-- Left wall
	elseif ball_transform:getPosition().x <= 5 then

		--[[
		assert(false, "Ran into left wall: " .. tostring(ball) .. " ; " .. tostring(wall))
		]]

		ball_transform:moveTo(1, ball_transform:getPosition().y)
		ball_movement:invertHorizontalVelocity()

	-- Right wall
	else
		
		--[[ assert(false, "Ran into right wall: " .. tostring(ball) .. " ; " .. 
					tostring(wall_position) .. tostring(wall))
		]]

		ball_transform:moveTo(love.graphics.getWidth() - ball_collider:hitbox().width, ball_transform:getPosition().y)
		ball_movement:invertHorizontalVelocity()
	end

end


function collideBallWithBrick(ball, brick)

	local ball_position = ball:getComponent(Transform):getPosition()
    local ball_movement = ball:getComponent(Motion)
    local ball_collider = ball:getComponent(Collider)
    local ball_rendering = ball:getComponent(Rendering)

	local brick_position = brick:getComponent(Transform):getPosition()
    local brick_collider = brick:getComponent(Collider)
    local brick_rendering = brick:getComponent(Rendering)

    brick_collider:disable()
    brick_rendering:disable()


	--brick:playDeathSound()
	--brick.active = false
	
	-- death animation

	--[[
	Tweener:addTween(1, brick, {width = 0, height = 0}, Easing.linear)
	Tweener:addTween(1, brick.position, {x = brick.position.x + 100, y = brick.position.y + 300}, Easing.inBack)
	Tweener:addTween(1, brick.color, {alpha = 0}, Easing.inCubic)
	]]

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
    if player_left_edge < wall_right_edge and player_right_edge > wall_right_edge then

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


    elseif player_right_edge > wall_left_edge and player_left_edge < wall_left_edge  then

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

        assert(false, "Collided but didn't detect right or left edge collision")

    end

end

