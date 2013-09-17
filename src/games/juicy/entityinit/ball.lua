require 'core.components.transform'
require 'core.components.rendering'
require 'core.components.collider'
require 'core.components.motion'
require 'core.components.behavior'
require 'core.components.inputresponse'
require 'core.components.soundcomponent'

require 'enums.tags'


Ball = {}

function Ball.init(world)

    local em = world:getEntityManager()

    local ball = em:createEntity('ball')
    ball:addComponent(Transform(395, 485))
    ball:addComponent(ShapeRendering():setColor(220,220,204):setShape(RectangleShape:new(15, 15)))
    ball:addComponent(Collider():setHitbox(RectangleShape:new(15, 15)))
    ball:addComponent(Motion():setMaxVelocity(600, 400):setMinVelocity(-600, -400):setVelocity(200, -425))
    ball:addComponent(Behavior():addUpdateFunction(ballAutoResetOnNonexistence))

    world:tagEntity(Tags.BALL, ball)

    local collision_system = world:getSystem(CollisionSystem)

    collision_system:watchCollision(ball, world:getTaggedEntity(Tags.PLAYER))
    collision_system:watchCollision(ball, world:getEntitiesInGroup(Tags.WALL_GROUP))
    collision_system:watchCollision(ball, world:getEntitiesInGroup(Tags.BRICK_GROUP))

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