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

require 'settings'

require 'enums.actions'

require 'core.entity.entityquery'
require 'core.vector'

local INPUTTABLE_ENTITIES = EntityQuery():addOrSet(InputResponse)
local BEHAVIOR_ENTITIES = EntityQuery():addOrSet(Behavior)
local MOVABLE_ENTITIES = EntityQuery():addOrSet(Transform):addOrSet(Motion)
local DRAWABLE_ENTITIES =  EntityQuery():addOrSet(TextRendering, ShapeRendering, ImageRendering):addOrSet(Transform)
local EMITTERS = EntityQuery():addOrSet(Emitter)


PlayScene = class('Play', Scene)



function PlayScene:initialize(name, w)

    Scene.initialize(self, name, w)

    local world = self.world

    -- Verbs for Play Scene
    local input_system = world:getInputSystem()
    input_system:registerInput(' ', Actions.FIRE)

end


function PlayScene:enter()


end

function PlayScene:update(dt)

    -- Update time system
   
    local time_system = self.world:getTimeSystem()
    time_system:update(dt)
    local game_world_dt = time_system:getDt()

   -- [[
    -- Update scheduled functions
    self.world:getScheduleSystem():update(game_world_dt)
    
    -- Update tweens 
    self.world:getTweenSystem():update(game_world_dt)

    -- Update input
    local inputtable = self.world:getEntityManager():query(INPUTTABLE_ENTITIES)
    self.world:getInputSystem():processInputResponses(inputtable, game_world_dt)

    -- Update Emitters 
    local emitters = self.world:getEntityManager():query(EMITTERS)
    self.world:getSystem(EmissionSystem):updateEmitters(emitters)

    -- Update behaviors
    local behaviorals = self.world:getEntityManager():query(BEHAVIOR_ENTITIES)
    self.world:getBehaviorSystem():processBehaviors(behaviorals, game_world_dt) 

    -- Update movement 
    local movables = self.world:getEntityManager():query(MOVABLE_ENTITIES)
    self.world:getMovementSystem():updateMovables(movables, game_world_dt)
  
    --]]
end


function PlayScene:draw()

    -- If we're currently paused, unpause
    self.world:getTimeSystem():go()

    local drawables = self.world:getEntityManager():query(DRAWABLE_ENTITIES)
    self.world:getRenderingSystem():renderDrawables(drawables)

    if Settings.DEBUG then
        self:outputDebugText()
    end


end


function PlayScene:outputDebugText()

    --[[
    local asset_manager = self.world:getAssetManager()
    local small_font = asset_manager:getFont(Assets.FONT_SMALL)
    love.graphics.setFont(small_font)

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
    ]]

    --[[
    local ball_history = self.world:getTaggedEntity(Tags.BALL):getComponent(History)
    --ålove.graphics.print("Time spent in history: " .. debug_time_in_history, 50, debugstart + 260)
    love.graphics.print("Ball History size: " .. ball_history:getComponentHistory(Transform):size(), 50, debugstart + 280)
    love.graphics.print("New Transform Objects created: " .. ball_transform.debug_objects_created, 50, debugstart + 300)
   

    frame = frame + 1

    if frame % 10 == 0 then
        memsize = collectgarbage('count')
    end

    love.graphics.print('Memory actually used (in kB): ' .. memsize, 50, debugstart + 320)
    love.graphics.print('Vector objects created: ' .. ClassCounter[Vector], 50, debugstart + 340)
    love.graphics.print('Set objects created: ' .. ClassCounter[Set], 50, debugstart + 360)
    love.graphics.print('List objects created: ' .. ClassCounter[List], 50, debugstart + 380)
    ]]


    --[[
    local confetti_maker = self.world:getTaggedEntity(Tags.CONFETTI_MAKER)
    local emitter = confetti_maker:getComponent(Emitter)
    love.graphics.print("Emitter Pool used: " .. emitter.object_pool.used_count, 50, debugstart + 260)
    love.graphics.print("Emitter Pool recycled: " .. emitter.object_pool.recycled_count, 50, debugstart + 280)
    love.graphics.print("Emitter Pool count limit: " .. emitter.object_pool.count_limit, 50, debugstart + 300)
    ]]
end



