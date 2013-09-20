require 'external.middleclass'
require 'core.scene'
require 'collections.set'
require 'core.entity.world'
require 'core.systems.menuguisystem'
require 'core.components.menugui'

require 'entitysets'

require 'enums.actions'
require 'enums.assets'
require 'enums.tags'


Menu = require 'entityinit.menu'

MenuScene = class('Menu', Scene)


function MenuScene:initialize(name, w)

    Scene.initialize(self, name, w)

    local world = self.world

    -- [[ Register Inputs ]]

    local em = world:getEntityManager()

    local asset_manager = world:getAssetManager()

    local large_font = asset_manager:getFont(Assets.FONT_LARGE)
    local medium_font = asset_manager:getFont(Assets.FONT_MEDIUM)
    local small_font = asset_manager:getFont(Assets.FONT_SMALL)

    local title = em:createEntity('title')
    title:addComponent(Transform(25, 100))
    title:addComponent(TextRendering("E C H O B R E A K O U T"):setColor(204,147,147):setFont(large_font))
    world:addEntityToGroup(Tags.MENU_GROUP, title)

    local credits1 = em:createEntity("credits1")
    credits1:addComponent(Transform(60, 500))
    credits1:addComponent(TextRendering("Press Enter to Select Level"):setColor(204,147,147):setFont(small_font))
    world:addEntityToGroup(Tags.MENU_GROUP, credits1)

    local credits2 = em:createEntity('credits2')
    credits2:addComponent(Transform(60, 530))
    credits2:addComponent(TextRendering("by @BDFife and @JimFingal"):setColor(204,147,147):setFont(small_font))
    world:addEntityToGroup(Tags.MENU_GROUP, credits2)


    --[[ Background Image ]]
    local menu_background = em:createEntity('menu_background')
    menu_background:addComponent(Transform(0, 0):setLayerOrder(10))
    menu_background:addComponent(ShapeRendering():setColor(63, 63, 63, 255):setShape(RectangleShape:new(love.graphics.getWidth(), love.graphics.getHeight())))
    world:addEntityToGroup(Tags.MENU_GROUP, menu_background)


    Menu.init(world)

end


function MenuScene:update(dt)

    local world = self.world

    local menu_scene_items = world:getEntitiesInGroup(Tags.MENU_GROUP)
 
    --[[ Update input ]]
    world:getSystem(InputSystem):processInputResponses(Set.intersection(menu_scene_items, entitiesRespondingToInput(world)), dt)


end


function MenuScene:draw()

    local world = self.world

    local menu_scene_items = world:getEntitiesInGroup(Tags.MENU_GROUP)

    world:getSystem(RenderingSystem):renderDrawables(Set.intersection(menu_scene_items, entitiesWithDrawability(world)))

   -- [[ TODO: hack, should be a renderable ]]

    local menu = world:getTaggedEntity(Tags.MENU)
    local menu_component = menu:getComponent(MenuGui)
    world:getSystem(MenuGuiSystem):drawMenu(menu_component)

    --[[
    local debugstart = 400

    if DEBUG then

        local player_transform =  world:getTaggedEntity(Tags.PLAYER):getComponent(Transform)
        local ball_transform = world:getTaggedEntity(Tags.BALL):getComponent(Transform)

        love.graphics.print("Ball x: " .. ball_transform.position.x, 50, debugstart + 20)
        love.graphics.print("Ball y: " .. ball_transform.position.y, 50, debugstart + 40)
        love.graphics.print("Player x: " .. player_transform.position.x, 50, debugstart + 60)
        love.graphics.print("Player y: " .. player_transform.position.y, 50, debugstart + 80)
    end

    ]]
end



--]]
