require 'core.components.transform'
require 'core.components.rendering'
require 'core.components.collider'
require 'core.components.motion'
require 'core.components.behavior'
require 'core.components.inputresponse'
require 'core.components.soundcomponent'

require 'behaviors.genericbehaviors'

require 'enums.tags'
require 'enums.palette'

require 'external.middleclass'
require 'core.entity.entitybuilder'

PlayerBuilder  = class('PlayerBuilder', EntityBuilder)

function PlayerBuilder:initialize(world)
    EntityBuilder.initialize(self, world, 'player')
    return self
end

function PlayerBuilder:create()

    EntityBuilder.create(self)

    self.entity:addComponent(Transform(350, 500))
    self.entity:addComponent(ShapeRendering():setColor(Palette.COLOR_PADDLE:unpack()):setShape(RectangleShape:new(100, 30)))
    self.entity:addComponent(Collider():setHitbox(RectangleShape:new(100, 30)))
    self.entity:addComponent(Motion():setMaxVelocity(800, 0):setMinVelocity(-800, 0):setDrag(800, 0))
    -- self.entity:addComponent(Behavior():addUpdateFunction(playerAI))

    self.entity:tag(Tags.PLAYER)
    self.entity:addToGroup(Tags.PLAY_GROUP)

   local behavior = Behavior()
    behavior:addUpdateFunction(constrainEntityToWorld)
    -- behavior:addUpdateFunction(playerAI)
    self.entity:addComponent(behavior)

    -- TODO Combine
    registerPlayerInputs(world)
    self.entity:addComponent(InputResponse():addResponse(playerInputResponse))

end 

function PlayerBuilder:reset()

    -- TODO

end




function registerPlayerInputs(world)

    local input_system = world:getInputSystem()

    -- Register Key Strokes
    input_system:registerInput('right', Actions.PLAYER_RIGHT)
    input_system:registerInput('left', Actions.PLAYER_LEFT)
    input_system:registerInput('a', Actions.PLAYER_LEFT)
    input_system:registerInput('d', Actions.PLAYER_RIGHT)
    input_system:registerInput(' ', Actions.RESET_BALL)

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
