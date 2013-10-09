require 'external.middleclass'
require 'entity.systems.renderingsystem'
require 'entity.systems.collisionsystem'
require 'entity.systems.movementsystem'
require 'entity.systems.behaviorsystem'
require 'entity.systems.camerasystem'
require 'entity.systems.inputsystem'
require 'entity.systems.tweensystem'
require 'entity.systems.schedulesystem'
require 'entity.systems.messagesystem'
require 'entity.systems.timesystem'
require 'entity.systems.statisticssystem'
require 'entity.systems.emissionsystem'
require 'entity.world'
require 'scenes.playscene'
require 'scenes.splashscene'

require 'enums.scenes'
require 'external.slam'

local world = nil

function love.load()
 
    world = World()

    loadAssets(world)
    loadSystems(world)
    loadScenes(world)

end

-- Load Fonts and Globally Used Assets
function loadAssets(world)

    local ps2p = "PressStart2P.ttf"
    
    local asset_manager = world:getAssetManager()
    asset_manager:loadFont(Assets.FONT_LARGE, ps2p, 30)
    asset_manager:loadFont(Assets.FONT_MEDIUM, ps2p, 18)
    asset_manager:loadFont(Assets.FONT_SMALL, ps2p, 14)

end


-- Initialize and Store World Systems
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


-- Initialize Game Scenes
function loadScenes(world)

    -- Only one scene here. TODO: Add Splash and Menu
    local scene_manager = world:getSceneManager()

    local splash_scene = SplashScene(Scenes.SPLASH, world)
    scene_manager:registerScene(splash_scene)

    local play_scene = PlayScene(Scenes.PLAY, world)
    scene_manager:registerScene(play_scene)

    scene_manager:changeScene(Scenes.SPLASH)
    
end


-- Perform computations, etc. between screen refreshes.
function love.update(dt)

    -- Defer to the update process in the current scene.
   world:getSceneManager():update(dt)

end

-- Update the screen.
function love.draw()

    -- Defer to the draw process in the current scene.
   world:getSceneManager():draw(dt)

end
