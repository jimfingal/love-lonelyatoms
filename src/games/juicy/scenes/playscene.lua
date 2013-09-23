require 'external.middleclass'
require 'core.scene'
require 'collections.set'
require 'core.entity.world'
require 'core.components.transform'
require 'core.components.rendering'
require 'core.components.collider'
require 'core.components.motion'
require 'core.components.behavior'
require 'core.components.inputresponse'
require 'core.components.soundcomponent'
require 'core.shapedata'
require 'behaviors.ballbehaviors'
require 'behaviors.playerbehaviors'
require 'entitysets'
require 'scripts.oldeffects'

require 'settings'

require 'enums.actions'
require 'enums.assets'
require 'enums.tags'
require 'enums.palette'

require 'entitybuilders.backgroundimage'
require 'entitybuilders.backgroundsound'
require 'entitybuilders.ball'
require 'entitybuilders.bricks'
require 'entitybuilders.eventslistener'
require 'entitybuilders.globalinput'
require 'entitybuilders.player'
require 'entitybuilders.walls'

GlobalEffects = require 'scripts.globaleffects'

PlayScene = class('Play', Scene)



local resetCollisionSystem = function(world)

    local collision_system = world:getSystem(CollisionSystem)

    collision_system:reset()
    collision_system:watchCollision(world:getTaggedEntity(Tags.BALL), world:getEntitiesInGroup(Tags.BRICK_GROUP))
    collision_system:watchCollision(world:getTaggedEntity(Tags.PLAYER), world:getEntitiesInGroup(Tags.WALL_GROUP))
    collision_system:watchCollision(world:getTaggedEntity(Tags.BALL), world:getTaggedEntity(Tags.PLAYER))
    collision_system:watchCollision(world:getTaggedEntity(Tags.BALL), world:getEntitiesInGroup(Tags.WALL_GROUP))

end


function PlayScene:initialize(name, w)

    Scene.initialize(self, name, w)

    local world = self.world

    self.effects = EffectDispatcher(world)

    -- Initialize entities
    self.ball_builder = BallBuilder(world)
    self.player_builder = PlayerBuilder(world)
    self.wall_builder = WallBuilder(world)
    self.brick_builder = BrickBuilder(world)
    self.background_image_builder = BackgroundImageBuilder(world)
    self.background_sound_builder = BackgroundSoundBuilder(world)
    self.global_input_builder = GlobalInputBuilder(world)
    self.events_listener_builder = EventsListenerBuilder(world)

    self.ball_builder:create()
    self.player_builder:create()
    self.wall_builder:create()
    self.brick_builder:create()
    self.background_image_builder:create()
    self.background_sound_builder:create()
    self.global_input_builder:create()
    self.events_listener_builder:create()


  
end

function PlayScene:reset()

    self.world:getTimeSystem():stop()
    
    self.ball_builder:reset()
    self.player_builder:reset()
    self.brick_builder:reset()

    resetCollisionSystem(self.world)

    -- TODO: add to brick reset
    if Settings.BRICKS_DROPIN then
        self.effects:dropInBricks()
    end

    -- TODO: add to player reset
    if Settings.PLAYER_DROPIN then
        self.effects:dropInPlayer()
    end

end

function PlayScene:enter()

    self:reset()

end

function PlayScene:update(love_dt)

    -- Update time system
    local time_system = world:getTimeSystem()

    time_system:update(love_dt)

    -- Spoof DT to be the current time system's dt
    local dt = time_system:getDt()

    -- Update scheduled functions
    self.world:getScheduleSystem():update(dt)

    -- Update tweens 
    self.world:getTweenSystem():update(dt)

    -- Update input
    self.world:getInputSystem():processInputResponses(entitiesRespondingToInput(world), dt)
    
    -- Update behaviors
    self.world:getBehaviorSystem():processBehaviors(entitiesWithBehavior(world), dt) 

    -- Update movement 

    self.world:getMovementSystem():updateMovables(entitiesWithMovement(world), dt)

    --[[ Handle collisions ]]

    local collision_system = self.world:getCollisionSystem()

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

    -- If we're currently paused, unpause
    self.world:getTimeSystem():go()

    love.graphics.setBackgroundColor(Palette.COLOR_BRICK:unpack())

    self.world:getRenderingSystem():renderDrawables(entitiesWithDrawability(world))

    local debugstart = 50

    if Settings.DEBUG then

        local player_transform =  world:getTaggedEntity(Tags.PLAYER):getComponent(Transform)
        local ball_transform = world:getTaggedEntity(Tags.BALL):getComponent(Transform)
        local ball_collider = world:getTaggedEntity(Tags.BALL):getComponent(Collider)

        love.graphics.print("Ball x: " .. ball_transform.position.x, 50, debugstart + 20)
        love.graphics.print("Ball y: " .. ball_transform.position.y, 50, debugstart + 40)
        love.graphics.print("Ball collider active: " .. tostring(ball_collider.active), 50, debugstart + 60)
        love.graphics.print("Player x: " .. player_transform.position.x, 50, debugstart + 80)
        love.graphics.print("Player y: " .. player_transform.position.y, 50, debugstart + 100)
        love.graphics.print("FPS: " .. love.timer.getFPS(), 50, debugstart + 120)

        local statistics_system = world:getStatisticsSystem()
        local timer_system = world:getTimeSystem()


        love.graphics.print("Number of times ball hit player: " .. statistics_system:getEventTally(Events.BALL_COLLISION_PLAYER), 50, debugstart + 140)
        love.graphics.print("Number of times ball hit wall: " .. statistics_system:getEventTally(Events.BALL_COLLISION_WALL), 50, debugstart + 160)
        love.graphics.print("Number of times ball hit brick: " .. statistics_system:getEventTally(Events.BALL_COLLISION_BRICK), 50, debugstart + 180)

        love.graphics.print("Time since ball hit player: " .. statistics_system:timeSinceLastEventOccurence(Events.BALL_COLLISION_PLAYER, timer_system:getTime()), 50, debugstart + 200)
        love.graphics.print("Time since ball hit wall: " .. statistics_system:timeSinceLastEventOccurence(Events.BALL_COLLISION_WALL, timer_system:getTime()), 50, debugstart + 220)
        love.graphics.print("Time since ball hit brick: " .. statistics_system:timeSinceLastEventOccurence(Events.BALL_COLLISION_BRICK, timer_system:getTime()), 50, debugstart + 240)



    end


end


