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
require 'core.entity.entityquery'



local Collisions = require 'scripts.collisions'
local PlayerBehaviors = require 'behaviors.playerbehaviors'
local BrickBehaviors = require 'behaviors.brickbehaviors'

local INPUTTABLE_ENTITIES = EntityQuery():addOrSet(InputResponse)
local BEHAVIOR_ENTITIES = EntityQuery():addOrSet(Behavior)
local MOVABLE_ENTITIES = EntityQuery():addOrSet(Transform):addOrSet(Motion)
local DRAWABLE_ENTITIES =  EntityQuery():addOrSet(Transform, ShapeRendering):addOrSet(Transform, TextRendering):addOrSet(Transform, ImageRendering)


PlayScene = class('Play', Scene)

function PlayScene:initialize(name, w)

    Scene.initialize(self, name, w)

    local world = self.world

    -- Verbs for Play Scene
    local input_system = world:getInputSystem()
    input_system:registerInput('right', Actions.PLAYER_RIGHT)
    input_system:registerInput('left', Actions.PLAYER_LEFT)
    input_system:registerInput('a', Actions.PLAYER_LEFT)
    input_system:registerInput('d', Actions.PLAYER_RIGHT)
    input_system:registerInput(' ', Actions.RESET_BALL)
    input_system:registerInput('escape', Actions.RESET_BOARD)
    input_system:registerInput('q', Actions.QUIT_GAME)

    -- Entities
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


function PlayScene:enter()

    self:reset()

end

function PlayScene:update(dt)

    -- Update time system
    local time_system = self.world:getTimeSystem()
    time_system:update(dt)
    local game_world_dt = time_system:getDt()

    -- Update scheduled functions
    self.world:getScheduleSystem():update(game_world_dt)

    -- Update tweens 
    self.world:getTweenSystem():update(game_world_dt)

    -- Update input
    local inputtable = self.world:getEntityManager():query(INPUTTABLE_ENTITIES)
    self.world:getInputSystem():processInputResponses(inputtable, game_world_dt)
    
    -- Update behaviors
    local behaviorals = self.world:getEntityManager():query(BEHAVIOR_ENTITIES)
    self.world:getBehaviorSystem():processBehaviors(behaviorals, game_world_dt) 

    -- Update movement 
    local movables = self.world:getEntityManager():query(MOVABLE_ENTITIES)
    self.world:getMovementSystem():updateMovables(movables, game_world_dt)
    
    -- Detect and Announce collisions
    local collision_system = self.world:getCollisionSystem()
    local collisions = collision_system:getCollisions()
    Collisions.announceCollisions(self.world, collisions)

end


function PlayScene:draw()

    -- If we're currently paused, unpause
    self.world:getTimeSystem():go()

    love.graphics.setBackgroundColor(Palette.COLOR_BRICK:unpack())

    local drawables = self.world:getEntityManager():query(DRAWABLE_ENTITIES)
    self.world:getRenderingSystem():renderDrawables(drawables)

    if Settings.DEBUG then
        self:outputDebugText()
    end


end


function PlayScene:reset()

    self.world:getTimeSystem():stop()
    
    self.ball_builder:reset()
    self.player_builder:reset()
    self.brick_builder:reset()

    Collisions.resetCollisionSystem(self.world)

    self.world:getMessageSystem():emitMessage(Events.GAME_RESET)

end


function PlayScene:outputDebugText()

    local debugstart = 50
    local player_transform =  self.world:getTaggedEntity(Tags.PLAYER):getComponent(Transform)
    local ball_transform = self.world:getTaggedEntity(Tags.BALL):getComponent(Transform)
    local ball_collider = self.world:getTaggedEntity(Tags.BALL):getComponent(Collider)

    love.graphics.print("Ball x: " .. ball_transform.position.x, 50, debugstart + 20)
    love.graphics.print("Ball y: " .. ball_transform.position.y, 50, debugstart + 40)
    love.graphics.print("Ball collider active: " .. tostring(ball_collider.active), 50, debugstart + 60)
    love.graphics.print("Player x: " .. player_transform.position.x, 50, debugstart + 80)
    love.graphics.print("Player y: " .. player_transform.position.y, 50, debugstart + 100)
    love.graphics.print("FPS: " .. love.timer.getFPS(), 50, debugstart + 120)

    local statistics_system = self.world:getStatisticsSystem()
    local timer_system = self.world:getTimeSystem()

    love.graphics.print("Number of times ball hit player: " .. statistics_system:getEventTally(Events.BALL_COLLISION_PLAYER), 50, debugstart + 140)
    love.graphics.print("Number of times ball hit wall: " .. statistics_system:getEventTally(Events.BALL_COLLISION_WALL), 50, debugstart + 160)
    love.graphics.print("Number of times ball hit brick: " .. statistics_system:getEventTally(Events.BALL_COLLISION_BRICK), 50, debugstart + 180)

    love.graphics.print("Time since ball hit player: " .. statistics_system:timeSinceLastEventOccurence(Events.BALL_COLLISION_PLAYER, timer_system:getTime()), 50, debugstart + 200)
    love.graphics.print("Time since ball hit wall: " .. statistics_system:timeSinceLastEventOccurence(Events.BALL_COLLISION_WALL, timer_system:getTime()), 50, debugstart + 220)
    love.graphics.print("Time since ball hit brick: " .. statistics_system:timeSinceLastEventOccurence(Events.BALL_COLLISION_BRICK, timer_system:getTime()), 50, debugstart + 240)

end



