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

require 'entitybuilders.mothershipbuilder'

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

    self.mothership_builder = MotherShipBuilder(world)

end


function PlayScene:enter()

    self.mothership_builder:create()

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
    local debugstart = 50
    love.graphics.print("FPS: " .. love.timer.getFPS(), 50, debugstart + 20)
end



