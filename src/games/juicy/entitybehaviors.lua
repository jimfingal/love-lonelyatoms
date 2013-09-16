require 'core.components.transform'
require 'core.components.rendering'
require 'core.components.collider'
require 'core.components.motion'
require 'core.vector'


function ballAutoResetOnNonexistence(ball, dt)

	local ball_transform = ball:getComponent(Transform)
    local ball_movement = ball:getComponent(Motion)
    local ball_collider = ball:getComponent(Collider)
    local ball_rendering = ball:getComponent(Rendering)

    local player = ball:getWorld():getTaggedEntity(Tags.PLAYER)

    local player_transform = player:getComponent(Transform)
    local player_render = player:getComponent(Rendering)


   if ball_collider.active == false then

   		ball_collider:enable()
   		ball_rendering:enable()
   		ball_movement:setVelocity(200, -425)

   		ball_transform:moveTo(player_transform:getPosition().x + player_render:getShape().width / 2, 
   							player_transform:getPosition().y - ball_collider:hitbox().height)


    end

end


function playerAI(player, dt)

	local player_position = player:getComponent(Transform):getPosition()
    local player_movement = player:getComponent(Motion)
    local player_shape = player:getComponent(Rendering):getShape()

    local ball_position = player:getWorld():getTaggedEntity(Tags.BALL):getComponent(Transform):getPosition()
    local ball_shape = player:getWorld():getTaggedEntity(Tags.BALL):getComponent(Rendering):getShape()
    local ball_movement = player:getWorld():getTaggedEntity(Tags.BALL):getComponent(Motion)


   	local paddle_origin = player_position.x
    local paddle_width = player_shape.width
    local third_of_paddle = paddle_width / 3

    local middle_ball = ball_position.x + ball_shape.width/2

    local first_third = paddle_origin + third_of_paddle
    local second_third = first_third + third_of_paddle
    local third_third = paddle_origin + paddle_width


    local speed_delta = Vector(1500, 0)
    local base_speed = Vector(200, 0)


    if middle_ball < first_third or ball_movement.velocity.x == 0 then

    	-- TODO
        -- player_movement:accelerateLeft(dt)
        if player_movement.velocity > Vector.ZERO then 
        	player_movement.velocity = -base_speed
    	end

    	player_movement.velocity = player_movement.velocity - (speed_delta * dt)


    elseif middle_ball > second_third then

		-- TODO
        -- self:accelerateRight(dt)
        if player_movement.velocity < Vector.ZERO then 
        	player_movement.velocity = base_speed
	    end

	    player_movement.velocity = player_movement.velocity + (speed_delta * dt)

    end


end

function playerInputResponse(player, held_actions, pressed_actions, dt)

    local speed_delta = Vector(2300, 0)
    local base_speed = Vector(200, 0)

    local player_movement = player:getComponent(Motion)

    if held_actions[Actions.PLAYER_RIGHT] then
    
        if player_movement.velocity < Vector.ZERO then 
            player_movement.velocity = base_speed
        end

        player_movement.velocity = player_movement.velocity + (speed_delta * dt)

    
    elseif held_actions[Actions.PLAYER_LEFT] then
    
        if player_movement.velocity > Vector.ZERO then 
            player_movement.velocity = -base_speed
        end

        player_movement.velocity = player_movement.velocity - (speed_delta * dt)

    end

end

function globalInputResponse(global, held_actions, pressed_actions, dt)


        -- Reset Ball
--    if pressed_actions[Actions.RESET_BALL] and not self.victory then
    if pressed_actions[Actions.RESET_BALL] then
  
        local ball = global:getWorld():getTaggedEntity(Tags.BALL)
        local player = global:getWorld():getTaggedEntity(Tags.PLAYER)

        local ball_transform = ball:getComponent(Transform)
        local ball_movement = ball:getComponent(Motion)
        local ball_collider = ball:getComponent(Collider)
        local ball_rendering = ball:getComponent(Rendering)

        local player = ball:getWorld():getTaggedEntity(Tags.PLAYER)

        local player_transform = player:getComponent(Transform)
        local player_render = player:getComponent(Rendering)


        ball_collider:enable()
        ball_rendering:enable()
        ball_movement:setVelocity(200, -425)

        ball_transform:moveTo(player_transform:getPosition().x + player_render:getShape().width / 2, 
                            player_transform:getPosition().y - ball_collider:hitbox().height)

    end

    -- Escape to Menu
    if pressed_actions[Actions.ESCAPE_TO_MENU] then

        --[[
        self.ball:disable()
        self.state_manager:changeState(States.MENU)
        ]]
    end



    move_speed = 100
    scale_speed = 2
    rotate_speed = 1

    local camera = global:getWorld():getSystem(CameraSystem).transform

    if held_actions[Actions.CAMERA_LEFT] then
        camera:move(-dt * move_speed, 0)
    end

    if held_actions[Actions.CAMERA_RIGHT] then
        camera:move(dt * move_speed, 0)
    end

    if held_actions[Actions.CAMERA_UP] then
        camera:move(0, -dt * move_speed)
    end

    if held_actions[Actions.CAMERA_DOWN] then
        camera:move(0, dt * move_speed)
    end

    if held_actions[Actions.CAMERA_SCALE_UP] then
        camera:addScale(dt * scale_speed)
    end

    if held_actions[Actions.CAMERA_SCALE_DOWN] then
        camera:addScale(-dt * scale_speed)
    end



    -- Quit
    if pressed_actions[Actions.QUIT_GAME] then
        love.event.push("quit")
    end

end

