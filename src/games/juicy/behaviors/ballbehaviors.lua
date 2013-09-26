
BallBehaviors = {}

function BallBehaviors.ballAutoResetOnNonexistence(ball, dt)

    local ball_transform = ball:getComponent(Transform)
    local ball_movement = ball:getComponent(Motion)
    local ball_collider = ball:getComponent(Collider)
    local ball_rendering = ball:getComponent(ShapeRendering)

    local player = ball:getWorld():getTaggedEntity(Tags.PLAYER)

    local player_transform = player:getComponent(Transform)
    local player_render = player:getComponent(ShapeRendering)


   if ball_collider.active == false then

        ball_collider:enable()
        ball_rendering:enable()
        ball_movement:setVelocity(200, -425)

        ball_transform:moveTo(player_transform:getPosition().x + player_render:getShape().width / 2, 
                            player_transform:getPosition().y - ball_collider:hitbox().height)


    end

end


function BallBehaviors.collideBallWithPaddle(ball, paddle)

    -- ball:getComponent(Messaging):emitMessage(Events.BALL_COLLISION_PLAYER, ball, paddle)

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



function BallBehaviors.collideBallWithWall(ball, wall)

    -- ball:getComponent(Messaging):emitMessage(Events.BALL_COLLISION_WALL, ball, wall)

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
        ball_movement:stop()

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


function BallBehaviors.collideBallWithBrick(ball, brick)

    -- ball:getComponent(Messaging):emitMessage(Events.BALL_COLLISION_BRICK, ball, brick)

    local ball_position = ball:getComponent(Transform):getPosition()
    local ball_movement = ball:getComponent(Motion)
    local ball_collider = ball:getComponent(Collider)

    local brick_position = brick:getComponent(Transform):getPosition()
    local brick_collider = brick:getComponent(Collider)

    -- Colliding from the left or right
    if ball_position.x < brick_position.x or
       ball_position.x > brick_position.x + brick_collider:hitbox().width then

        ball_movement:invertHorizontalVelocity()
    else
        ball_movement:invertVerticalVelocity()
    end

end

return BallBehaviors