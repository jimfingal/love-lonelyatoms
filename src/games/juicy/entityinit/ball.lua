require 'core.components.transform'
require 'core.components.rendering'
require 'core.components.collider'
require 'core.components.motion'
require 'core.components.behavior'
require 'core.components.inputresponse'
require 'core.components.soundcomponent'
require 'core.components.messaging'
require 'core.systems.messagesystem'
require 'enums.events'
require 'enums.tags'
require 'enums.palette'
require 'behaviors.genericbehaviors'

require 'entityinit.entityinitializer'

require 'external.middleclass'

BallInitializer  = class('BallInitializer', EntityInitializer)

function BallInitializer:initialize(world)
    EntityInitializer.initialize(self, world, 'ball')
    return self
end

function BallInitializer:createEntity()

    self.entity:addComponent(Transform(395, 485))
    self.entity:addComponent(ShapeRendering():setColor(Palette.COLOR_BALL:unpack()):setShape(RectangleShape:new(15, 15)))
    self.entity:addComponent(Collider():setHitbox(RectangleShape:new(15, 15)))
    self.entity:addComponent(Motion():setMaxVelocity(600, 400):setMinVelocity(-600, -400):setVelocity(200, -425))
    -- self.entity:addComponent(Behavior():addUpdateFunction(ballAutoResetOnNonexistence))
    self.entity:addComponent(InputResponse():addResponse(ballInputResponse))
    self.entity:addComponent(Messaging(world:getSystem(MessageSystem)))

    self:addSelfToGroup(Tags.PLAY_GROUP)
    self:tagSelf(Tags.BALL)

    local ball_behavior = Behavior()
    ball_behavior:addUpdateFunction(constrainEntityToWorld)
    -- ball_behavior:addUpdateFunction(ballAutoResetOnNonexistence)
    self.entity:addComponent(ball_behavior)

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