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
require 'core.components.soundcomponent'
require 'core.shapedata'
require 'collisionbehaviors'
require 'entitybehaviors'
require 'entitysets'
require 'external.slam'

require 'enums.actions'
require 'enums.assets'
require 'enums.tags'


DEBUG = false

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
    player:addComponent(ShapeRendering():setColor(147,147,205):setShape(RectangleShape:new(100, 20)))
    player:addComponent(Collider():setHitbox(RectangleShape:new(100, 20)))
    player:addComponent(Motion():setMaxVelocity(800, 0):setMinVelocity(-800, 0):setDrag(800, 0))
    -- player:addComponent(Behavior():addUpdateFunction(playerAI))
    player:addComponent(InputResponse():addResponse(playerInputResponse))


    world:tagEntity(Tags.PLAYER, player)

    local ball = em:createEntity('ball')
    ball:addComponent(Transform(395, 485))
    ball:addComponent(ShapeRendering():setColor(220,220,204):setShape(RectangleShape:new(15, 15)))
    ball:addComponent(Collider():setHitbox(RectangleShape:new(15, 15)))
    ball:addComponent(Motion():setMaxVelocity(600, 400):setMinVelocity(-600, -400):setVelocity(200, -425))
    ball:addComponent(Behavior():addUpdateFunction(ballAutoResetOnNonexistence))

    world:tagEntity(Tags.BALL, ball)



    local world_constrainer = em:createEntity('world_constrainer')
    world_constrainer:addComponent(Behavior():addUpdateFunction(constrainActorsToWorld))


     
    local background_image = em:createEntity('background_image')
    background_image:addComponent(Transform(0, 0):setLayerOrder(10))
    background_image:addComponent(ShapeRendering():setColor(63, 63, 63, 255):setShape(RectangleShape:new(love.graphics.getWidth(), love.graphics.getHeight())))
    world:tagEntity(Tags.BACKGROUND, background_image)
    


    local bsnd = "background.mp3"

    local asset_manager = world:getAssetManager()

    asset_manager:loadSound(Assets.BACKGROUND_SOUND, bsnd)

    local this_sound = asset_manager:getSound(Assets.BACKGROUND_SOUND)
    this_sound:setVolume(0.25)
    this_sound:setLooping(true)

    local background_sound_entity = em:createEntity('background_sound')
    background_sound_entity:addComponent(SoundComponent():addSound(Assets.BACKGROUND_SOUND, this_sound))

    local sound_component = background_sound_entity:getComponent(SoundComponent)

    local retrieved_sound = sound_component:getSound(Assets.BACKGROUND_SOUND)
    love.audio.play(retrieved_sound)


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


    local brick_snd = "brick.mp3"
   
    asset_manager:loadSound(Assets.BRICK_SOUND, brick_snd)


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
                brick:addComponent(ShapeRendering():setColor(this_color:unpack()):setShape(RectangleShape:new(100, 20)))
                brick:addComponent(Collider():setHitbox(RectangleShape:new(100, 20)))
                brick:addComponent(SoundComponent():addSound(Assets.BRICK_SOUND, asset_manager:getSound(Assets.BRICK_SOUND)))

                world:addEntityToGroup(Tags.BRICK_GROUP, brick)

            end
        end



    -- Tends to fall off world
    local TILE_SIZE = 20

    local top_tile = em:createEntity('top_tile')
    top_tile:addComponent(Transform(0, -1 * TILE_SIZE + 1))
    top_tile:addComponent(Collider():setHitbox(RectangleShape:new(love.graphics.getWidth(), TILE_SIZE)))
    top_tile:addComponent(ShapeRendering():setColor(147,147,205):setShape(RectangleShape:new(love.graphics.getWidth(), TILE_SIZE)))


    local bottom_tile = em:createEntity('bottom_tile')
    bottom_tile:addComponent(Transform(0, love.graphics.getHeight() - 1))
    bottom_tile:addComponent(Collider():setHitbox(RectangleShape:new(love.graphics.getWidth(), TILE_SIZE)))
    bottom_tile:addComponent(ShapeRendering():setColor(147,147,205):setShape(RectangleShape:new(love.graphics.getWidth(), TILE_SIZE)))

    local left_tile = em:createEntity('left_tile')
    left_tile:addComponent(Transform(-1 * TILE_SIZE + 1, 0))
    left_tile:addComponent(Collider():setHitbox(RectangleShape:new(TILE_SIZE, love.graphics.getHeight())))
    left_tile:addComponent(ShapeRendering():setColor(147,147,205):setShape(RectangleShape:new(TILE_SIZE, love.graphics.getHeight())))

    local right_tile = em:createEntity('right_tile')
    right_tile:addComponent(Transform(love.graphics.getWidth() - 1, 0))
    right_tile:addComponent(Collider():setHitbox(RectangleShape:new(TILE_SIZE, love.graphics.getHeight())))
    right_tile:addComponent(ShapeRendering():setColor(147,147,205):setShape(RectangleShape:new(TILE_SIZE, love.graphics.getHeight())))


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

    -- Update tweenns
    world:getSystem(TweenSystem):update(dt)

    -- Update inout
    world:getSystem(InputSystem):processInputResponses(entitiesRespondingToInput(world), dt)
    
    -- Update behaviors
    world:getSystem(BehaviorSystem):processBehaviors(entitiesWithBehavior(world), dt) 

    -- Update movement
    world:getSystem(MovementSystem):updateMovables(entitiesWithMovement(world), dt)

    -- Handle collisions
    local collision_system = world:getSystem(CollisionSystem)

    local collisions = collision_system:getCollisions()

    for collision_event in collisions:members() do

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

    -- love.graphics.setBackgroundColor(63, 63, 63, 255)

    world:getSystem(RenderingSystem):renderDrawables(entitiesWithDrawability(world))

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
