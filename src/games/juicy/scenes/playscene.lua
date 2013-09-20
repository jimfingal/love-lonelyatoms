require 'external.middleclass'
require 'core.scene'
require 'collections.set'
require 'core.systems.renderingsystem'
require 'core.systems.collisionsystem'
require 'core.systems.movementsystem'
require 'core.systems.behaviorsystem'
require 'core.systems.camerasystem'
require 'core.systems.inputsystem'
require 'core.systems.tweensystem'
require 'core.systems.schedulesystem'
require 'core.systems.timesystem'
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
require 'effects'
require 'settings'

require 'enums.actions'
require 'enums.assets'
require 'enums.tags'
require 'enums.palette'


Ball = require 'entityinit.ball'
Bricks = require 'entityinit.bricks'
Player = require 'entityinit.player'
Walls = require 'entityinit.walls'

PlayScene = class('Play', Scene)

function PlayScene:initialize(name, w)

    Scene.initialize(self, name, w)

    local world = self.world

    self.effects = EffectDispatcher(world)

    -- [[ Register Inputs ]]

    local input_system = world:getSystem(InputSystem)

    input_system:registerInput('right', Actions.PLAYER_RIGHT)
    input_system:registerInput('left', Actions.PLAYER_LEFT)
    input_system:registerInput('a', Actions.PLAYER_LEFT)
    input_system:registerInput('d', Actions.PLAYER_RIGHT)
    input_system:registerInput(' ', Actions.RESET_BALL)
    input_system:registerInput('escape', Actions.RESET_BOARD)
    input_system:registerInput('q', Actions.QUIT_GAME)


    local em = world:getEntityManager()

    --[[ Script dealing with special input ]]

    local ir = em:createEntity('globalinputresponse')
    ir:addComponent(InputResponse():addResponse(globalInputResponse))
    world:addEntityToGroup(Tags.PLAY_GROUP, ir)

    --[[ Background Image ]]

    local play_background = em:createEntity('play_background')
    play_background:addComponent(Transform(0, 0):setLayerOrder(10))
    play_background:addComponent(ShapeRendering():setColor(Palette.COLOR_BACKGROUND:unpack()):setShape(RectangleShape:new(love.graphics.getWidth(), love.graphics.getHeight())))
    world:tagEntity(Tags.BACKGROUND, play_background)
    world:addEntityToGroup(Tags.PLAY_GROUP, play_background)


    --[[ Script constraining things to world in case they go too fast]]

    local world_constrainer = em:createEntity('world_constrainer')
    world_constrainer:addComponent(Behavior():addUpdateFunction(constrainActorsToWorld))
    world:addEntityToGroup(Tags.PLAY_GROUP, world_constrainer)


    --[[ Background sound ]]
    local asset_manager = world:getAssetManager()
    local bsnd = "background.mp3"

    local this_sound = asset_manager:loadSound(Assets.BACKGROUND_SOUND, bsnd)
    this_sound:setVolume(0.25)
    this_sound:setLooping(true)
    this_sound:play()

    local background_sound_entity = em:createEntity('background_sound')
    background_sound_entity:addComponent(SoundComponent():addSound(Assets.BACKGROUND_SOUND, this_sound))
    world:tagEntity(Tags.BACKGROUND_SOUND, background_sound_entity)
    world:addEntityToGroup(Tags.PLAY_GROUP, background_sound_entity)


    --[[ Initialize complicated entities ]]

    Walls.init(world)
    Ball.init(world)

    local message_system = world:getSystem(MessageSystem)

    -- Global listener that sets effects
    local panopticon = em:createEntity('panopticon')
    world:tagEntity(Tags.PANOPTICON, panopticon)

    local pan_message = Messaging(world:getSystem(MessageSystem))
    panopticon:addComponent(pan_message)

    pan_message:registerMessageResponse(Events.BALL_COLLISION_PLAYER, function(ball, player)

        EffectDispatcher.cameraShake()
        EffectDispatcher.allEffects(ball, 2, 1.5)
        EffectDispatcher.scaleEntity(player, 1.5, 1.3)
        --EffectDispatcher.rotateJitter(player, 1)

    end)

    pan_message:registerMessageResponse(Events.BALL_COLLISION_BRICK, function(ball, brick)

        EffectDispatcher.cameraShake()
        EffectDispatcher.allEffects(ball, 2, 1.5)
        EffectDispatcher.slowMo(0.5)
        --EffectDispatcher.cameraZoom(brick)


    end)

    pan_message:registerMessageResponse(Events.BALL_COLLISION_WALL, function(ball, wall)
        
        EffectDispatcher.cameraShake()
        EffectDispatcher.allEffects(ball, 2, 1.5)
        EffectDispatcher.scaleEntity(wall, 5, 5)


    end)

  
end

function PlayScene:reset()

    love.audio.stop()

    local world = self.world

    world:getSystem(TimeSystem):stop()

    Bricks.init(world)
    Player.init(world)

    local collision_system = world:getSystem(CollisionSystem)

    collision_system:reset()

    collision_system:watchCollision(world:getTaggedEntity(Tags.BALL), world:getEntitiesInGroup(Tags.BRICK_GROUP))
    collision_system:watchCollision(world:getTaggedEntity(Tags.PLAYER), world:getEntitiesInGroup(Tags.WALL_GROUP))
    collision_system:watchCollision(world:getTaggedEntity(Tags.BALL), world:getTaggedEntity(Tags.PLAYER))
    collision_system:watchCollision(world:getTaggedEntity(Tags.BALL), world:getEntitiesInGroup(Tags.WALL_GROUP))

    local sound_component =  world:getTaggedEntity(Tags.BACKGROUND_SOUND):getComponent(SoundComponent)
    local retrieved_sound = sound_component:getSound(Assets.BACKGROUND_SOUND)
    love.audio.play(retrieved_sound)
    
    local ball = world:getTaggedEntity(Tags.BALL)
    local ball_collider = ball:getComponent(Collider)
    local ball_rendering = ball:getComponent(ShapeRendering)

    ball_collider:disable()
    ball_rendering:disable()


    if Settings.BRICKS_DROPIN then
        self.effects:dropInBricks()
    end

    if Settings.PLAYER_DROPIN then
        self.effects:dropInPlayer()
    end

end

function PlayScene:enter()

    self:reset()

end

function PlayScene:update(love_dt)


    local world = self.world

    local time_system = world:getSystem(TimeSystem)

    time_system:update(love_dt)

    -- Spoof DT to be the current time system's dt
    local dt = time_system:getDt()

    --[[ Update scheduled functions ]] 
    world:getSystem(ScheduleSystem):update(dt)

    --[[ Update tweens ]] 
    world:getSystem(TweenSystem):update(dt)

    --[[ Update input ]]
    world:getSystem(InputSystem):processInputResponses(entitiesRespondingToInput(world), dt)
    
    --[[ Update behaviors ]]
    world:getSystem(BehaviorSystem):processBehaviors(entitiesWithBehavior(world), dt) 

    --[[ Update movement ]]
    world:getSystem(MovementSystem):updateMovables(entitiesWithMovement(world), dt)

    --[[ Handle collisions ]]

    local collision_system = world:getSystem(CollisionSystem)

    local collisions = collision_system:getCollisions()

    -- TODO: don't have if / elses
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
   


end


function PlayScene:draw()

    local world = self.world

    -- If we're currently paused, unpause
    world:getSystem(TimeSystem):go()

    love.graphics.setBackgroundColor(Palette.COLOR_BRICK:unpack())

    world:getSystem(RenderingSystem):renderDrawables(entitiesWithDrawability(world))

    local debugstart = 400

    if DEBUG then

        local player_transform =  world:getTaggedEntity(Tags.PLAYER):getComponent(Transform)
        local ball_transform = world:getTaggedEntity(Tags.BALL):getComponent(Transform)
        local ball_collider = world:getTaggedEntity(Tags.BALL):getComponent(Collider)

        love.graphics.print("Ball x: " .. ball_transform.position.x, 50, debugstart + 20)
        love.graphics.print("Ball y: " .. ball_transform.position.y, 50, debugstart + 40)
        love.graphics.print("Ball collider active: " .. tostring(ball_collider.active), 50, debugstart + 60)
        love.graphics.print("Player x: " .. player_transform.position.x, 50, debugstart + 80)
        love.graphics.print("Player y: " .. player_transform.position.y, 50, debugstart + 100)
        love.graphics.print("FPS: " .. love.timer.getFPS(), 50, debugstart + 120)

    end


end