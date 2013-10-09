require 'entity.components.transform'
require 'entity.components.rendering'
require 'entity.components.collider'
require 'entity.components.motion'
require 'entity.components.behavior'
require 'entity.components.inputresponse'
require 'entity.components.soundcomponent'

require 'enums.tags'


Ball = {}

function Ball.init(world)

    local em = world:getEntityManager()

    local ball = em:createEntity('ball')
    ball:addComponent(Transform(395, 485))
    ball:addComponent(Rendering():addRenderable(ShapeRendering():setColor(220,220,204):setShape(RectangleShape:new(15, 15))))
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
        local ball_rendering = ball:getComponent(Rendering)

        local player = ball:getWorld():getTaggedEntity(Tags.PLAYER)

        local player_transform = player:getComponent(Transform)
        local player_render = player:getComponent(Rendering):getRenderable()


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
    local ball_rendering = ball:getComponent(Rendering)

    local player = ball:getWorld():getTaggedEntity(Tags.PLAYER)

    local player_transform = player:getComponent(Transform)
    local player_render = player:getComponent(Rendering):getRenderable()


   if ball_collider.active == false then

        ball_collider:enable()
        ball_rendering:enable()
        ball_movement:setVelocity(200, -425)

        ball_transform:moveTo(player_transform:getPosition().x + player_render:getShape().width / 2, 
                            player_transform:getPosition().y - ball_collider:hitbox().height)


    end

end

return Ball