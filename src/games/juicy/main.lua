require 'external.middleclass'
require 'core.oldentity.group'
require 'core.systems.renderingsystem'
require 'core.systems.collisionsystem'
require 'core.systems.movementsystem'
require 'core.entity.world'
require 'core.components.transform'
require 'core.components.rendering'
require 'core.components.collider'
require 'core.components.motion'
require 'core.shapedata'


DEBUG = false

function love.load()
 
    world = World()

    local rendering_system = RenderingSystem()
    local collision_system = CollisionSystem(world)
    local movement_system = MovementSystem()

    world:setSystem(rendering_system)
    world:setSystem(collision_system)
    world:setSystem(movement_system)

    local em = world:getEntityManager()

    player = em:createEntity('player')
    em:addComponent(player, Transform(350, 500))
    em:addComponent(player, Rendering():setColor(147,147,205):setShape(RectangleShape:new(100, 20)))
    em:addComponent(player, Collider():setHitbox(RectangleShape:new(100, 20)))
    em:addComponent(player, Motion():setMaxVelocity(800, 0):setMinVelocity(-800, 0):setDrag(800, 0))

    ball = em:createEntity('ball')
    em:addComponent(ball, Transform(395, 485))
    em:addComponent(ball, Rendering():setColor(220,220,204):setShape(RectangleShape:new(15, 15)))
    em:addComponent(ball, Collider():setHitbox(RectangleShape:new(100, 20)))
    em:addComponent(ball, Motion():setMaxVelocity(600, 400):setMinVelocity(-600, -400):setVelocity(200, -425))

    auto_world_edges = Group()

    -- Tends to fall off world
    local TILE_SIZE = 20

    local top_tile = em:createEntity('top_tile')
    em:addComponent(top_tile, Transform(0, -1 * TILE_SIZE))
    em:addComponent(top_tile, Collider():setHitbox(RectangleShape:new(love.graphics.getWidth(), TILE_SIZE)))

    local bottom_tile = em:createEntity('bottom_tile')
    em:addComponent(bottom_tile, Transform(0, love.graphics.getHeight()))
    em:addComponent(bottom_tile, Collider():setHitbox(RectangleShape:new(love.graphics.getWidth(), TILE_SIZE)))

    local left_tile = em:createEntity('left_tile')
    em:addComponent(left_tile, Transform(-1 * TILE_SIZE, 0))
    em:addComponent(left_tile, Collider():setHitbox(RectangleShape:new(TILE_SIZE, love.graphics.getHeight())))

    local right_tile = em:createEntity('right_tile')
    em:addComponent(right_tile, Transform(love.graphics.getWidth(), 0))
    em:addComponent(right_tile, Collider():setHitbox(RectangleShape:new(TILE_SIZE, love.graphics.getHeight())))

    auto_world_edges:add(top_tile)
    auto_world_edges:add(bottom_tile)   
    auto_world_edges:add(left_tile)
    auto_world_edges:add(right_tile)



    --[[
    collision_system:watchCollision(player, auto_world_edges, collidePlayerWithWall)
    collision_system:watchCollision(ball, player, collideBallWithPaddle)
    collision_system:watchCollision(ball, auto_world_edges, collideBallWithWall)
    ]]



end

-- Perform computations, etc. between screen refreshes.
function love.update(dt)

  
   -- TODO 
    -- auto_player:processAI(dt, auto_ball)

    local collision_system = world:getSystem(CollisionSystem)
    local movement_system = world:getSystem(MovementSystem)
    local em = world:getEntityManager()

    for entity in em:getAllEntitiesContainingComponents(Transform, Motion):members() do

        t = em:getComponent(entity, Transform)
        m = em:getComponent(entity, Motion)
        movement_system:update(t, m, dt)

    end

    collision_system:processCollisions()

    --[[
    if auto_ball.active == false then
        auto_ball:reset(auto_player)
    end
    ]]

    constrainActorsToWorld()


end

-- Update the screen.
function love.draw()

    love.graphics.setBackgroundColor(63, 63, 63, 255)

    local rendering_system = world:getSystem(RenderingSystem)
    local em = world:getEntityManager()

    for entity in em:getAllEntitiesContainingComponents(Transform, Rendering):members() do

        t = em:getComponent(entity, Transform)
        r = em:getComponent(entity, Rendering)
        rendering_system:draw(t, r)
        
    end

    local debugstart = 400

    if DEBUG then

        local player_transform = em:getComponent(player, Transform)
        local ball_transform = em:getComponent(ball, Transform)

        love.graphics.print("Ball x: " .. ball_transform.position.x, 50, debugstart + 20)
        love.graphics.print("Ball y: " .. ball_transform.position.y, 50, debugstart + 40)
        love.graphics.print("Player x: " .. player_transform.position.x, 50, debugstart + 60)
        love.graphics.print("Player y: " .. player_transform.position.y, 50, debugstart + 80)
    end

end


-- Special off-world handling for long load times

function constrainActorsToWorld()

    local em = world:getEntityManager()

    local player_transform = em:getComponent(player, Transform)
    local player_collider = em:getComponent(player, Collider)

    local ball_transform = em:getComponent(ball, Transform)


    if ball_transform.position.x < 0 then
        ball_transform.position.x = 0
    elseif ball_transform.position.x > love.graphics.getWidth() - 50 then
        ball_transform.position.x = love.graphics.getWidth() - 50
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