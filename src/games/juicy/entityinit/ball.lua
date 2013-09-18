require 'core.components.transform'
require 'core.components.rendering'
require 'core.components.collider'
require 'core.components.motion'
require 'core.components.behavior'
require 'core.components.inputresponse'
require 'core.components.soundcomponent'

require 'enums.tags'
require 'enums.palette'


Ball = {}

function Ball.init(world)

    local em = world:getEntityManager()

    local ball = em:createEntity('ball')
    ball:addComponent(Transform(395, 485))
    ball:addComponent(ShapeRendering():setColor(Palette.COLOR_BALL:unpack()):setShape(RectangleShape:new(15, 15)))
    ball:addComponent(Collider():setHitbox(RectangleShape:new(15, 15)))
    ball:addComponent(Motion():setMaxVelocity(600, 400):setMinVelocity(-600, -400):setVelocity(200, -425))
    -- ball:addComponent(Behavior():addUpdateFunction(ballAutoResetOnNonexistence))
    ball:addComponent(InputResponse():addResponse(ballInputResponse))

    world:tagEntity(Tags.BALL, ball)
    world:addEntityToGroup(Tags.PLAY_GROUP, ball)


end 

function ballInputResponse(ball, held_actions, pressed_actions, dt)

    if pressed_actions[Actions.RESET_BALL] then
  
        local player = ball:getWorld():getTaggedEntity(Tags.PLAYER)

        local ball_transform = ball:getComponent(Transform)
        local ball_movement = ball:getComponent(Motion)
        local ball_collider = ball:getComponent(Collider)
        local ball_rendering = ball:getComponent(ShapeRendering)

        local player = ball:getWorld():getTaggedEntity(Tags.PLAYER)

        local player_transform = player:getComponent(Transform)
        local player_render = player:getComponent(ShapeRendering)


        ball_collider:enable()
        ball_rendering:enable()
        ball_movement:setVelocity(200, -425)

        ball_transform:moveTo(player_transform:getPosition().x + player_render:getShape().width / 2, 
                            player_transform:getPosition().y - ball_collider:hitbox().height)

    end

end

function ballAutoResetOnNonexistence(ball, dt)

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

return Ball