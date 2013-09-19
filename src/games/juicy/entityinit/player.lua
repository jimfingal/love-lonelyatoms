require 'core.components.transform'
require 'core.components.rendering'
require 'core.components.collider'
require 'core.components.motion'
require 'core.components.behavior'
require 'core.components.inputresponse'
require 'core.components.soundcomponent'

require 'enums.tags'
require 'enums.palette'

Player = {}

function Player.init(world)

    local em = world:getEntityManager()

    local player = world:getTaggedEntity(Tags.PLAYER)

    if not player then 
        player = em:createEntity('player')
    end

    player:addComponent(Transform(350, 200))
    player:addComponent(ShapeRendering():setColor(Palette.COLOR_PADDLE:unpack()):setShape(RectangleShape:new(50, 20)))
    player:addComponent(Collider():setHitbox(RectangleShape:new(100, 30)))
    player:addComponent(Motion():setMaxVelocity(800, 0):setMinVelocity(-800, 0):setDrag(800, 0))
    -- player:addComponent(Behavior():addUpdateFunction(playerAI))
    player:addComponent(InputResponse():addResponse(playerInputResponse))


    local tween_system = world:getSystem(TweenSystem)

    tween_system:addTween(1 + math.random(), player:getComponent(ShapeRendering):getShape(), {width = 100, height = 30}, Easing.outBounce)
    tween_system:addTween(1 + math.random(), player:getComponent(Transform):getPosition(), {x = 350, y = 500}, Easing.outBounce)



    world:tagEntity(Tags.PLAYER, player)
    world:addEntityToGroup(Tags.PLAY_GROUP, player)




end 


function playerAI(player, dt)

    local player_position = player:getComponent(Transform):getPosition()
    local player_movement = player:getComponent(Motion)
    local player_shape = player:getComponent(ShapeRendering):getShape()

    local ball_position = player:getWorld():getTaggedEntity(Tags.BALL):getComponent(Transform):getPosition()
    local ball_shape = player:getWorld():getTaggedEntity(Tags.BALL):getComponent(ShapeRendering):getShape()
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

return Player