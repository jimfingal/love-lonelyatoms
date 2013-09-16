require 'external.middleclass'
require 'core.oldentity.group'
require 'core.systems.renderingsystem'
require 'core.systems.collisionsystem'
require 'core.systems.movementsystem'
require 'core.systems.behaviorsystem'
require 'core.entity.world'
require 'core.components.transform'
require 'core.components.rendering'
require 'core.components.collider'
require 'core.components.motion'
require 'core.components.behavior'
require 'core.shapedata'
require 'collisionbehaviors'
require 'entitybehaviors'

DEBUG = false

Tags = {}

Tags.PLAYER = "player"
Tags.BALL = "ball"
Tags.WALL_GROUP = "walls"

function love.load()
 
    world = World()

    local rendering_system = RenderingSystem()
    local collision_system = CollisionSystem(world)
    local movement_system = MovementSystem()
    local behavior_system = BehaviorSystem()

    world:setSystem(rendering_system)
    world:setSystem(collision_system)
    world:setSystem(movement_system)
    world:setSystem(behavior_system)

    local em = world:getEntityManager()

    local player = em:createEntity('player')
    player:addComponent(Transform(350, 500))
    player:addComponent(Rendering():setColor(147,147,205):setShape(RectangleShape:new(100, 20)))
    player:addComponent(Collider():setHitbox(RectangleShape:new(100, 20)))
    player:addComponent(Motion():setMaxVelocity(800, 0):setMinVelocity(-800, 0):setDrag(800, 0))
    player:addComponent(Behavior():addUpdateFunction(playerAI))

    world:tagEntity(Tags.PLAYER, player)

    local ball = em:createEntity('ball')
    ball:addComponent(Transform(395, 485))
    ball:addComponent(Rendering():setColor(220,220,204):setShape(RectangleShape:new(15, 15)))
    ball:addComponent(Collider():setHitbox(RectangleShape:new(15, 15)))
    ball:addComponent(Motion():setMaxVelocity(600, 400):setMinVelocity(-600, -400):setVelocity(200, -425))
    ball:addComponent(Behavior():addUpdateFunction(ballAutoResetOnNonexistence))

    world:tagEntity(Tags.BALL, ball)

    -- Tends to fall off world
    local TILE_SIZE = 20

    local top_tile = em:createEntity('top_tile')
    top_tile:addComponent(Transform(0, -1 * TILE_SIZE + 1))
    top_tile:addComponent(Collider():setHitbox(RectangleShape:new(love.graphics.getWidth(), TILE_SIZE)))
    top_tile:addComponent(Rendering():setColor(147,147,205):setShape(RectangleShape:new(love.graphics.getWidth(), TILE_SIZE)))


    local bottom_tile = em:createEntity('bottom_tile')
    bottom_tile:addComponent(Transform(0, love.graphics.getHeight() - 1))
    bottom_tile:addComponent(Collider():setHitbox(RectangleShape:new(love.graphics.getWidth(), TILE_SIZE)))
    bottom_tile:addComponent(Rendering():setColor(147,147,205):setShape(RectangleShape:new(love.graphics.getWidth(), TILE_SIZE)))

    local left_tile = em:createEntity('left_tile')
    left_tile:addComponent(Transform(-1 * TILE_SIZE + 1, 0))
    left_tile:addComponent(Collider():setHitbox(RectangleShape:new(TILE_SIZE, love.graphics.getHeight())))
    left_tile:addComponent(Rendering():setColor(147,147,205):setShape(RectangleShape:new(TILE_SIZE, love.graphics.getHeight())))

    local right_tile = em:createEntity('right_tile')
    right_tile:addComponent(Transform(love.graphics.getWidth() - 1, 0))
    right_tile:addComponent(Collider():setHitbox(RectangleShape:new(TILE_SIZE, love.graphics.getHeight())))
    right_tile:addComponent(Rendering():setColor(147,147,205):setShape(RectangleShape:new(TILE_SIZE, love.graphics.getHeight())))


    world:addEntityToGroup(Tags.WALL_GROUP, top_tile)
    world:addEntityToGroup(Tags.WALL_GROUP, bottom_tile)
    world:addEntityToGroup(Tags.WALL_GROUP, left_tile)
    world:addEntityToGroup(Tags.WALL_GROUP, right_tile)

    collision_system:watchCollision(player, world:getEntitiesInGroup(Tags.WALL_GROUP))
    collision_system:watchCollision(ball, player)
    collision_system:watchCollision(ball, world:getEntitiesInGroup(Tags.WALL_GROUP))


end

-- Perform computations, etc. between screen refreshes.
function love.update(dt)

    local em = world:getEntityManager()

    local collision_system = world:getSystem(CollisionSystem)
    local movement_system = world:getSystem(MovementSystem)
    local behavior_system = world:getSystem(BehaviorSystem)

    
    behavior_system:processBehaviors(em:getAllEntitiesContainingComponent(Behavior), dt) 

    for entity in em:getAllEntitiesContainingComponents(Transform, Motion):members() do

        t = entity:getComponent(Transform)
        m = entity:getComponent(Motion)

        movement_system:update(t, m, dt)

    end

    for collision_event in collision_system:getCollisions():members() do

        if collision_event.a == world:getTaggedEntity(Tags.PLAYER) and
           world:getGroupsContainingEntity(collision_event.b):contains(Tags.WALL_GROUP) then

           collidePlayerWithWall(collision_event.a, collision_event.b)

        elseif collision_event.a == world:getTaggedEntity(Tags.BALL) and
           world:getGroupsContainingEntity(collision_event.b):contains(Tags.WALL_GROUP) then

          collideBallWithWall(collision_event.a, collision_event.b)

        elseif collision_event.a == world:getTaggedEntity(Tags.BALL) and
           collision_event.b == world:getTaggedEntity(Tags.PLAYER) then

           collideBallWithPaddle(collision_event.a, collision_event.b)


        end

    end

    --[[
    if auto_ball.active == false then
        auto_ball:reset(auto_player)
    end
    ]]

    -- constrainActorsToWorld()


end

-- Update the screen.
function love.draw()

    love.graphics.setBackgroundColor(63, 63, 63, 255)

    local rendering_system = world:getSystem(RenderingSystem)
    local em = world:getEntityManager()

    for entity in em:getAllEntitiesContainingComponents(Transform, Rendering):members() do

        t = entity:getComponent(Transform)
        r = entity:getComponent(Rendering)
        rendering_system:draw(t, r)
        
    end

    local debugstart = 400

    if DEBUG then

        local player_transform =  world:getTaggedEntity(Tags.PLAYER):getComponent(Transform)
        local ball_transform = world:getTaggedEntity(Tags.BALL):getComponent(Transform)

        love.graphics.print("Ball x: " .. ball_transform.position.x, 50, debugstart + 20)
        love.graphics.print("Ball y: " .. ball_transform.position.y, 50, debugstart + 40)
        love.graphics.print("Player x: " .. player_transform.position.x, 50, debugstart + 60)
        love.graphics.print("Player y: " .. player_transform.position.y, 50, debugstart + 80)
    end

end


-- Special off-world handling for long load times

function constrainActorsToWorld()

    local em = world:getEntityManager()

    local player_transform =  world:getTaggedEntity(Tags.PLAYER):getComponent(Transform)
    local player_collider = world:getTaggedEntity(Tags.PLAYER):getComponent(Collider)

    local ball_transform = world:getTaggedEntity(Tags.BALL):getComponent(Transform)


    if ball_transform.position.x < 0 then
        ball_transform.position.x = 0
    elseif ball_transform.position.x > love.graphics.getWidth() then
        ball_transform.position.x = love.graphics.getWidth()
    end

    if ball_transform.position.y < 0 then
        ball_transform.position.y = 0
    elseif ball_transform.position.y > love.graphics.getHeight() then
        ball_transform.position.y = love.graphics.getHeight()
    end

    if player_transform.position.x < 0 then
        player_transform.position.x = 0
    elseif player_transform.position.x > love.graphics.getWidth() - player_collider:hitbox().width then
        player_transform.position.x = love.graphics.getWidth() - player_collider:hitbox().width
    end

end