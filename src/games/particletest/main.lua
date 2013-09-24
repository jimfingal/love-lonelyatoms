require 'external.middleclass'
require 'core.systems.renderingsystem'
require 'core.systems.collisionsystem'
require 'core.systems.movementsystem'
require 'core.systems.behaviorsystem'
require 'core.systems.camerasystem'
require 'core.systems.inputsystem'
require 'core.systems.tweensystem'
require 'core.systems.menuguisystem'
require 'core.systems.schedulesystem'
require 'core.systems.messagesystem'
require 'core.systems.timesystem'
require 'core.systems.statisticssystem'
require 'core.systems.emissionsystem'


require 'core.components.transform'
require 'core.components.rendering'
require 'core.components.collider'
require 'core.components.motion'
require 'core.components.behavior'
require 'core.components.inputresponse'
require 'core.components.soundcomponent'
require 'core.components.emitter'

require 'core.shapedata'


require 'core.entity.entityquery'
require 'core.entity.world'
require 'external.slam'

DEBUG = false


local EMITTERS = EntityQuery():addOrSet(Emitter)
local MOVABLE_ENTITIES = EntityQuery():addOrSet(Transform):addOrSet(Motion)
local DRAWABLE_ENTITIES =  EntityQuery():addOrSet(Transform, ShapeRendering):addOrSet(Transform, TextRendering):addOrSet(Transform, ImageRendering)



function love.load()
 
    world = World()

    loadSystems(world)

    local em = world:getEntityManager()

    local particle_emitter = em:createEntity('emitter')

    particle_emitter:addComponent(Transform(350, 500))
    particle_emitter:addComponent(ShapeRendering():setColor(Color.fromHex("e97f02"):unpack()):setShape(RectangleShape:new(100, 30)))

    local emitter_component = Emitter()
    emitter_component:setNumberOfEmissions(3)

    local emissionFunction = function()

        local world = particle_emitter:getWorld()
        local pe_transform = particle_emitter:getComponent(Transform)

        local emitted_entity =  em:createEntity()
        emitted_entity:addComponent(Transform(pe_transform:getPosition().x, pe_transform:getPosition().y))
        emitted_entity:addComponent(ShapeRendering():setColor(math.random(255), math.random(255), math.random(255)):setShape(RectangleShape:new(10, 10)))
        emitted_entity:addComponent(Motion():setVelocity(0, -30))

        local schedule_system = world:getSystem(ScheduleSystem)
        schedule_system:doAfter(2, function() particle_emitter:getComponent(Emitter):recycle(emitted_entity) end)

        return emitted_entity
    end

    emitter_component:setEmissionFunction(emissionFunction)

    local resetFunction = function(emitted_entity)

        local pe_transform = particle_emitter:getComponent(Transform)
        emitted_entity:getComponent(Transform):moveTo(pe_transform:getPosition().x, pe_transform:getPosition().y)
        emitted_entity:getComponent(Motion):setVelocity(0, -30)
        emitted_entity:getComponent(ShapeRendering):enable()

        local schedule_system = world:getSystem(ScheduleSystem)
        schedule_system:doAfter(2, function() particle_emitter:getComponent(Emitter):recycle(emitted_entity) end)

    end

    emitter_component:setResetFunction(resetFunction)

    local recycleFunction = function(emitted_entity)

        local pe_transform = particle_emitter:getComponent(Transform)
        emitted_entity:getComponent(ShapeRendering):disable()
        emitted_entity:getComponent(Motion):stop()

        local schedule_system = world:getSystem(ScheduleSystem)

    end

    emitter_component:setRecycleFunction(recycleFunction)


    local schedule_system = world:getSystem(ScheduleSystem)

    emitter_component:start()

    schedule_system:doEvery(1, function() emitter_component:makeReady() end)

    particle_emitter:addComponent(emitter_component)
    world:tagEntity("particle_emitter", particle_emitter)

end


function loadSystems(world)

    local rendering_system = RenderingSystem()
    local camera_system = CameraSystem()
    rendering_system:setCamera(camera_system)
    world:setSystem(rendering_system)
    world:setSystem(camera_system)


    local collision_system = CollisionSystem(world)
    world:setSystem(collision_system)

    local movement_system = MovementSystem()
    world:setSystem(movement_system)

    local behavior_system = BehaviorSystem()
    world:setSystem(behavior_system)

    local input_system = InputSystem()
    world:setSystem(input_system)

    local tween_system = TweenSystem()
    world:setSystem(tween_system)

    local menu_system = MenuGuiSystem(world)
    world:setSystem(menu_system)

    local schedule_system = ScheduleSystem(world)
    world:setSystem(schedule_system)

    local message_system = MessageSystem()
    world:setSystem(message_system)

    local time_system = TimeSystem()
    world:setSystem(time_system)

    local statistics_system = StatisticsSystem()
    world:setSystem(statistics_system)

    local emission_system = EmissionSystem()
    world:setSystem(emission_system)

end



-- Perform computations, etc. between screen refreshes.
function love.update(dt)

    local time_system = world:getSystem(TimeSystem)

    time_system:update(dt)

    -- Spoof DT to be the current time system's dt
    local dt = time_system:getDt()

    --[[ Update scheduled functions ]] 
    world:getSystem(ScheduleSystem):update(dt)

    --[[ Update tweens ]] 
    world:getSystem(TweenSystem):update(dt)

    -- [[ Update Emitters ]]
    world:getSystem(EmissionSystem):updateEmitters(entitiesWithEmitters(world))

    --[[ Update movement ]]
    world:getSystem(MovementSystem):updateMovables(entitiesWithMovement(world), dt)

end

-- Update the screen.

function love.draw()

    world:getSystem(TimeSystem):go()
    world:getSystem(RenderingSystem):renderDrawables(entitiesWithDrawability(world))

    local debugstart = 50

    if DEBUG then

        local pe = world:getTaggedEntity("particle_emitter")
        local e = pe:getComponent(Emitter)
        love.graphics.print("Emitter active: " .. tostring(e:isActive()), 50, debugstart + 20)
        love.graphics.print("Emitter ready: " .. tostring(e:isReady()), 50, debugstart + 40)

        --[[
        love.graphics.print("Ball x: " .. ball_transform.position.x, 50, debugstart + 20)
        love.graphics.print("Ball y: " .. ball_transform.position.y, 50, debugstart + 40)
        love.graphics.print("Ball collider active: " .. tostring(ball_collider.active), 50, debugstart + 60)
        love.graphics.print("Player x: " .. player_transform.position.x, 50, debugstart + 80)
        love.graphics.print("Player y: " .. player_transform.position.y, 50, debugstart + 100)
        love.graphics.print("FPS: " .. love.timer.getFPS(), 50, debugstart + 120)

        local statistics_system = world:getSystem(StatisticsSystem)
        local timer_system = world:getSystem(TimeSystem)


        love.graphics.print("Number of times ball hit player: " .. statistics_system:getEventTally(Events.BALL_COLLISION_PLAYER), 50, debugstart + 140)
        love.graphics.print("Number of times ball hit wall: " .. statistics_system:getEventTally(Events.BALL_COLLISION_WALL), 50, debugstart + 160)
        love.graphics.print("Number of times ball hit brick: " .. statistics_system:getEventTally(Events.BALL_COLLISION_BRICK), 50, debugstart + 180)

        love.graphics.print("Time since ball hit player: " .. statistics_system:timeSinceLastEventOccurence(Events.BALL_COLLISION_PLAYER, timer_system:getTime()), 50, debugstart + 200)
        love.graphics.print("Time since ball hit wall: " .. statistics_system:timeSinceLastEventOccurence(Events.BALL_COLLISION_WALL, timer_system:getTime()), 50, debugstart + 220)
        love.graphics.print("Time since ball hit brick: " .. statistics_system:timeSinceLastEventOccurence(Events.BALL_COLLISION_BRICK, timer_system:getTime()), 50, debugstart + 240)
        ]]


    end

end


function entitiesWithMovement(world)
    return world:getEntityManager():query(MOVABLE_ENTITIES)
end


function entitiesWithDrawability(world)
    return world:getEntityManager():query(DRAWABLE_ENTITIES)
end

function entitiesWithEmitters(world)
   
    return world:getEntityManager():query(EMITTERS)

end