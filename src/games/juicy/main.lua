require 'external.middleclass'
require 'core.oldentity.group'
require 'core.systems.renderingsystem'
require 'core.systems.collisionsystem'
require 'core.systems.movementsystem'
require 'core.systems.behaviorsystem'
require 'core.systems.camerasystem'
require 'core.systems.inputsystem'
require 'core.systems.tweensystem'
require 'core.entity.world'
require 'core.components.transform'
require 'core.components.rendering'
require 'core.components.collider'
require 'core.components.motion'
require 'core.components.behavior'
require 'core.components.inputresponse'
require 'core.shapedata'
require 'collisionbehaviors'
require 'entitybehaviors'

DEBUG = false

Tags = {}

Tags.PLAYER = "player"
Tags.BALL = "ball"
Tags.WALL_GROUP = "walls"
Tags.BRICK_GROUP = "bricks"

Actions = {}

Actions.PLAYER_LEFT = "left"
Actions.PLAYER_RIGHT = "right" 

Actions.RESET_BALL = "reset"

Actions.SKIP_SPLASH = "skip"

Actions.QUIT_GAME = "quit"
Actions.ESCAPE_TO_MENU = "escape"


Actions.CAMERA_LEFT = "cleft"
Actions.CAMERA_RIGHT = "cright" 
Actions.CAMERA_UP = "cup" 
Actions.CAMERA_DOWN = "cdown" 
Actions.CAMERA_SCALE_UP = "cscaleup"
Actions.CAMERA_SCALE_DOWN = "cscaledown"


function love.load()
 
    world = World()

    local rendering_system = RenderingSystem()
    local collision_system = CollisionSystem(world)
    local movement_system = MovementSystem()
    local behavior_system = BehaviorSystem()
    local input_system = InputSystem()

    local camera_system = CameraSystem()
    local tween_system = TweenSystem()

    rendering_system:setCamera(camera_system)

    world:setSystem(rendering_system)
    world:setSystem(collision_system)
    world:setSystem(movement_system)
    world:setSystem(behavior_system)
    world:setSystem(input_system)
    world:setSystem(camera_system)
    world:setSystem(tween_system)



    input_system:registerInput('right', Actions.PLAYER_RIGHT)
    input_system:registerInput('left', Actions.PLAYER_LEFT)
    input_system:registerInput('a', Actions.PLAYER_LEFT)
    input_system:registerInput('d', Actions.PLAYER_RIGHT)
    input_system:registerInput(' ', Actions.RESET_BALL)
    input_system:registerInput('escape', Actions.ESCAPE_TO_MENU)
    input_system:registerInput('q', Actions.QUIT_GAME)

    input_system:registerInput('f', Actions.CAMERA_LEFT)
    input_system:registerInput('h', Actions.CAMERA_RIGHT)
    input_system:registerInput('t', Actions.CAMERA_UP)
    input_system:registerInput('g', Actions.CAMERA_DOWN)
    input_system:registerInput('z', Actions.CAMERA_SCALE_UP)
    input_system:registerInput('x', Actions.CAMERA_SCALE_DOWN)


    local em = world:getEntityManager()

    local ir = em:createEntity('globalinputresponse')
    ir:addComponent(InputResponse():addResponse(globalInputResponse))


    local player = em:createEntity('player')
    player:addComponent(Transform(350, 500))
    player:addComponent(Rendering():setColor(147,147,205):setShape(RectangleShape:new(100, 20)))
    player:addComponent(Collider():setHitbox(RectangleShape:new(100, 20)))
    player:addComponent(Motion():setMaxVelocity(800, 0):setMinVelocity(-800, 0):setDrag(800, 0))
    -- player:addComponent(Behavior():addUpdateFunction(playerAI))
    player:addComponent(InputResponse():addResponse(playerInputResponse))


    world:tagEntity(Tags.PLAYER, player)

    local ball = em:createEntity('ball')
    ball:addComponent(Transform(395, 485))
    ball:addComponent(Rendering():setColor(220,220,204):setShape(RectangleShape:new(15, 15)))
    ball:addComponent(Collider():setHitbox(RectangleShape:new(15, 15)))
    ball:addComponent(Motion():setMaxVelocity(600, 400):setMinVelocity(-600, -400):setVelocity(200, -425))
    ball:addComponent(Behavior():addUpdateFunction(ballAutoResetOnNonexistence))

    world:tagEntity(Tags.BALL, ball)


    -- Bricks
    local c1 = 205
    local c2 = 147
    local c3 = 176
        
    local colors = List()

    colors:append(Color:new(c1, c2, c2))
    colors:append(Color:new(c1, c2, c3))
    colors:append(Color:new(c1, c2, c1))
    colors:append(Color:new(c3, c2, c1))
    colors:append(Color:new(c2, c2, c1))
    colors:append(Color:new(c2, c3, c1))
    colors:append(Color:new(c2, c1, c1))
    colors:append(Color:new(c2, c1, c3))
    colors:append(Color:new(c2, c1, c2))
    colors:append(Color:new(c3, c1, c2))

    for y = 0, 60, 20 do

            local x_start = 0
            local x_end = 700

            if y > 0 and y % 40 == 20 then 
                x_start = 50
                x_end = 650
            end

            for x=x_start, x_end, 100 do

                local random = math.random(1, colors:size())

                local this_color = colors:memberAt(random)

                local brick = em:createEntity('brick' .. y .. x)
                brick:addComponent(Transform(x, y):setLayerOrder(2))
                brick:addComponent(Rendering():setColor(this_color:unpack()):setShape(RectangleShape:new(100, 20)))
                brick:addComponent(Collider():setHitbox(RectangleShape:new(100, 20)))

                world:addEntityToGroup(Tags.BRICK_GROUP, brick)

            end
        end



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
    collision_system:watchCollision(ball, world:getEntitiesInGroup(Tags.BRICK_GROUP))


end

-- Perform computations, etc. between screen refreshes.
function love.update(dt)

    local em = world:getEntityManager()

    local collision_system = world:getSystem(CollisionSystem)
    local movement_system = world:getSystem(MovementSystem)
    local behavior_system = world:getSystem(BehaviorSystem)
    local input_system = world:getSystem(InputSystem)
    local tween_system = world:getSystem(TweenSystem)

    tween_system:update(dt)


    input_system:processInputResponses(em:getAllEntitiesContainingComponent(InputResponse), dt)
    
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
      
        elseif collision_event.a == world:getTaggedEntity(Tags.BALL) and
           world:getGroupsContainingEntity(collision_event.b):contains(Tags.BRICK_GROUP) then

          collideBallWithBrick(collision_event.a, collision_event.b)

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

    rendering_system:renderDrawables(em:getAllEntitiesContainingComponents(Transform, Rendering))

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