require 'external.middleclass'
require 'game.scene'
require 'collections.set'
require 'entity.world'
require 'entity.components.transform'
require 'entity.components.rendering'
require 'entity.components.collider'
require 'entity.components.motion'
require 'entity.components.behavior'
require 'entity.components.inputresponse'
require 'entity.components.soundcomponent'

require 'game.shapedata'
require 'entity.systems.tweensystem'

require 'settings'

require 'enums.actions'

require 'entitybuilders.mothershipbuilder'
require 'entitybuilders.opponentbuilder'
require 'entitybuilders.starbuilder'
require 'entitybuilders.seekerbuilder'

require 'entity.entityquery'
require 'math.vector2'
require 'math.quad.aabb'
require 'math.quad.quadtree'

require 'behaviors.coroutinebehaviors'

bloom = require 'shaders.bloom'

local INPUTTABLE_ENTITIES = EntityQuery():addOrSet(InputResponse)
local BEHAVIOR_ENTITIES = EntityQuery():addOrSet(Behavior)
local COBEHAVIOR_ENTITIES = EntityQuery():addOrSet(CoroutineBehavior)
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
    self.star_builder = StarBuilder(world)
    --self.opponent_builder = OpponentBuilder(world)
    self.seeker_builder = SeekerBuilder(world)

    local aabb = AABB(0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    self.root_node = QuadTree(aabb, 0, 10, 5)

end


function PlayScene:enter()

    self.mothership_builder:create()
    self.star_builder:create()
    -- self.opponent_builder:create()
    self.seeker_builder:create()

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

    -- Update Input
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


    if frame % 5 == 0 then
        self.root_node:clear()
        --for p in particle_system:getParticlePool(PointParticle).used_objects:members() do
        for p in particle_system:getParticlePool(BulletParticle).used_objects:members() do
            self.root_node:insert(p)
        end
    end

    if frame % 100 == 0 then
        self.root_node:prune()
    end
  

    --]]
end


function PlayScene:draw()

    -- If we're currently paused, unpause
    self.world:getTimeSystem():go()

    love.graphics.setBackgroundColor(Palette.COLOR_BACKGROUND:unpack())

    self:drawQuadTree(self.root_node)
    
    -- Should be moved into rendering system probably

    local particle_system =  self.world:getSystem(ParticleSystem)
    particle_system:drawParticles()

    local drawables = self.world:getEntityManager():query(DRAWABLE_ENTITIES)
    self.world:getRenderingSystem():renderDrawables(drawables)

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

    love.graphics.print('Memory actually used (in kB): ' .. memsize, 10, debugstart + 120)
    love.graphics.print('Vector objects created: ' .. ClassCounter[Vector2], 10, debugstart + 140)
    love.graphics.print('Set objects created: ' .. ClassCounter[Set], 10, debugstart + 160)
    love.graphics.print('List objects created: ' .. ClassCounter[List], 10, debugstart + 180)
    --love.graphics.print('Tweens: ' .. tostring(self.world:getSystem(TweenSystem)), 10, debugstart + 400)

    local seeker = self.world:getTaggedEntity(Tags.SEEKER)
    local transform = seeker:getComponent(Transform)
    local motion = seeker:getComponent(Motion)
    -- Seeeker
    love.graphics.print('Seeker Position:    ' .. tostring(transform:getPosition()), 10, debugstart + 300)
    love.graphics.print('Seeker Velocity:    ' .. tostring(motion:getVelocity()), 10, debugstart + 320)
    love.graphics.print('Seeker Acceleraton: ' .. tostring(motion:getAcceleration()), 10, debugstart + 340)



end

function PlayScene:drawQuadTree(qt)
    love.graphics.setColor(147,147,205)

    self:drawAABB(qt.aabb)

    for i, node in qt.child_nodes:members() do
         self:drawQuadTree(node)
    end

end


function PlayScene:drawAABB(box, mode)
    love.graphics.rectangle(mode or "line", box.x, box.y, box.w, box.h)
end


