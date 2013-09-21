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

require 'core.components.transform'
require 'core.components.rendering'
require 'core.components.collider'
require 'core.components.motion'
require 'core.components.behavior'
require 'core.components.inputresponse'
require 'core.components.soundcomponent'
require 'core.components.emitter'

require 'core.shapedata'


require 'core.entity.world'
require 'external.slam'

DEBUG = true

function love.load()
 
    world = World()

    loadSystems(world)

    local em = world:getEntityManager()

    local particle_emitter = em:createEntity('player')

    particle_emitter:addComponent(Transform(350, 500))
    particle_emitter:addComponent(ShapeRendering():setColor(Color.fromHex("e97f02"):unpack()):setShape(RectangleShape:new(100, 30)))

    local emitter_component = Emitter()

    particle_emitter:addComponent(ShapeRendering():setColor(Color.fromHex("e97f02"):unpack()):setShape(RectangleShape:new(100, 30)))

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

end

-- Update the screen.

function love.draw()

    world:getSystem(TimeSystem):go()
    world:getSystem(RenderingSystem):renderDrawables(entitiesWithDrawability(world))

end


function entitiesWithDrawability(world)
   
    local em = world:getEntityManager()

    local drawables = Set()
    drawables:addSet(em:getAllEntitiesContainingComponents(Transform, ShapeRendering))
    drawables:addSet(em:getAllEntitiesContainingComponents(Transform, TextRendering))
    drawables:addSet(em:getAllEntitiesContainingComponents(Transform, ImageRendering))    

    return drawables
end