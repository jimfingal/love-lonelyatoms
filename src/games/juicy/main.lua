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

require 'core.entity.world'
require 'scenes.playscene'
require 'enums.scenes'
require 'external.slam'

DEBUG = true

function love.load()
 
    world = World()

    loadAssets(world)
    loadSystems(world)
    loadScenes(world)

end

function loadAssets(world)

    -- TODO: load sounds

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


function loadScenes(world)

    local scene_manager = world:getSceneManager()

    local play_scene = PlayScene(Scenes.PLAY, world)
    scene_manager:registerScene(play_scene)

    scene_manager:changeScene(Scenes.PLAY)
    


end

-- Perform computations, etc. between screen refreshes.
function love.update(dt)

   world:getSceneManager():update(dt)

end

-- Update the screen.

function love.draw()

   world:getSceneManager():draw(dt)

end
