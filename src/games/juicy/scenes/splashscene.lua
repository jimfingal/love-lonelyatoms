require 'external.middleclass'
require 'game.scene'
require 'collections.set'
require 'entity.world'
require 'entity.entityquery'
require 'entity.components.rendering'

require 'enums.actions'
require 'enums.tags'
require 'enums.palette'

require 'game.generic.genericbehaviors'

local BEHAVIOR_ENTITIES = EntityQuery():addOrSet(Behavior)
local DRAWABLE_ENTITIES =  EntityQuery():addOrSet(Rendering):addOrSet(Transform)

SplashScene = class('Splash', Scene)

function SplashScene:initialize(name, w)

    Scene.initialize(self, name, w)

end

function SplashScene:enter(dt)

    self.world:getTimeSystem():stop()

    local em = self.world:getEntityManager()

    local asset_manager = self.world:getAssetManager()

    local large_font = asset_manager:getFont(Assets.FONT_LARGE)
    local small_font = asset_manager:getFont(Assets.FONT_SMALL)

    -- Main Title
    local title = em:createEntity('title')
    title:addComponent(Transform(25, 100))
    title:addComponent(Rendering():addRenderable(TextRendering("J U I C Y B R E A K O U T"):setColor(Palette.COLOR_BRICK:unpack()):setFont(large_font)))
    title:tag(Tags.TITLE)
    GenericBehaviors.dropIn(title, self.world)

    -- Instructions Title

    local instructions = em:createEntity("instructions")
    instructions:addComponent(Transform(60, 500))
    instructions:addComponent(Rendering():addRenderable(TextRendering("Press Enter To Start Game"):setColor(Palette.COLOR_BRICK:unpack()):setFont(small_font)))
    instructions:tag(Tags.INSTRUCTIONS)
    GenericBehaviors.dropIn(instructions, self.world)

    local input_system =  self.world:getSystem(InputSystem)
    input_system:registerInput('return', Actions.START_GAME)

    -- Input responsiveness to start game

    local start_game = em:createEntity("start_game")
    local start_behavior = Behavior()
    start_game:addComponent(start_behavior)

    local start = function()
        -- Clean up
        local input_system = self.world:getInputSystem()
        input_system:clear()
        title:kill()
        instructions:kill()
        start_game:kill()

        local scene_manager = self.world:getSceneManager()
        scene_manager:changeScene(Scenes.PLAY)

    end

    local detect_start = function()
        local input_system = self.world:getInputSystem()
        if input_system:newAction(Actions.START_GAME) then
            start()
        end
    end

    start_behavior:addUpdateFunction(detect_start)

end

function SplashScene:update(dt)

    -- Update time system
    local time_system = self.world:getTimeSystem()
    time_system:update(dt)
    local game_world_dt = time_system:getDt()

    -- Update scheduled functions
    self.world:getScheduleSystem():update(game_world_dt)

    -- Update tweens 
    self.world:getTweenSystem():update(game_world_dt)

    -- Update input
    self.world:getInputSystem():update(dt)

    -- Update behaviors
    local behaviorals = self.world:getEntityManager():query(BEHAVIOR_ENTITIES)
    self.world:getBehaviorSystem():processBehaviors(behaviorals, game_world_dt) 

end


function SplashScene:draw()

    love.graphics.setBackgroundColor(Palette.COLOR_BACKGROUND:unpack())

    -- If we're currently paused, unpause
    self.world:getTimeSystem():go()

    local drawables = self.world:getEntityManager():query(DRAWABLE_ENTITIES)
    self.world:getRenderingSystem():renderDrawables(drawables)

end



