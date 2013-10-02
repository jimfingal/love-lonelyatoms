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
require 'core.systems.tweensystem'

require 'settings'

require 'enums.actions'

require 'entitybuilders.mothershipbuilder'
require 'entitybuilders.opponentbuilder'

require 'core.entity.entityquery'
require 'core.vector'

local INPUTTABLE_ENTITIES = EntityQuery():addOrSet(InputResponse)
local BEHAVIOR_ENTITIES = EntityQuery():addOrSet(Behavior)
local MOVABLE_ENTITIES = EntityQuery():addOrSet(Transform):addOrSet(Motion)
local DRAWABLE_ENTITIES =  EntityQuery():addOrSet(Rendering):addOrSet(Transform)
local EMITTERS = EntityQuery():addOrSet(Emitter)

local frame = 0
local memsize = 0

PlayScene = class('Play', Scene)

function PlayScene:initialize(name, w)

    Scene.initialize(self, name, w)

    local world = self.world

    -- Verbs for Play Scene
    local input_system = world:getInputSystem()
    input_system:registerInput(' ', Actions.FIRE)
    input_system:registerInput('right', Actions.RIGHT)
    input_system:registerInput('left', Actions.LEFT)
    input_system:registerInput('up', Actions.UP)
    input_system:registerInput('down', Actions.DOWN)

    self.mothership_builder = MotherShipBuilder(world)
    -- self.opponent_builder = OpponentBuilder(world)

end


function PlayScene:enter()

    self.mothership_builder:create()
    -- self.opponent_builder:create()

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
  

    local particle_system =  self.world:getSystem(ParticleSystem)
    particle_system:updateParticles(game_world_dt)

    --]]
end


function PlayScene:draw()

    -- If we're currently paused, unpause
    self.world:getTimeSystem():go()

    love.graphics.setBackgroundColor(Palette.COLOR_BACKGROUND:unpack())


    local drawables = self.world:getEntityManager():query(DRAWABLE_ENTITIES)
    self.world:getRenderingSystem():renderDrawables(drawables)
    
    -- Should be moved into rendering system probably
    local particle_system =  self.world:getSystem(ParticleSystem)
    particle_system:drawParticles()


    if Settings.DEBUG then

        frame = frame + 1
        self:outputDebugText()
    end


end


function PlayScene:outputDebugText()
    local debugstart = 50
    love.graphics.setColor(255, 255, 255)
    love.graphics.print("FPS: " .. love.timer.getFPS(), 50, debugstart + 20)

    frame = frame + 1

    if frame % 10 == 0 then
        memsize = collectgarbage('count')
    end

    love.graphics.print('Memory actually used (in kB): ' .. memsize, 10, debugstart + 320)
    love.graphics.print('Vector objects created: ' .. ClassCounter[Vector], 10, debugstart + 340)
    love.graphics.print('Set objects created: ' .. ClassCounter[Set], 10, debugstart + 360)
    love.graphics.print('List objects created: ' .. ClassCounter[List], 10, debugstart + 380)
    --love.graphics.print('Tweens: ' .. tostring(self.world:getSystem(TweenSystem)), 10, debugstart + 400)


end



