require 'core.components.transform'
require 'core.components.rendering'
require 'core.components.collider'
require 'core.components.motion'
require 'core.components.behavior'
require 'core.components.inputresponse'
require 'core.components.soundcomponent'

require 'enums.tags'
require 'enums.actions'


Menu = {}

local sceneChanger = function(song)

        local scene_function = 
                function () 
                    world:getSceneManager():changeScene(Scenes.PLAY, song) 
                end
        return scene_function

end

local backgroundPlayer =  function(song)
        -- Hack -- read from con

        local filename = song .. "_background.mp3"
        
        local asset_manager = world:getAssetManager()

        local background_function = function()
            
            asset_manager:loadSound(filename, filename)

            love.audio.stop()
            local background = asset_manager:getSound(filename)
            background:setVolume(0.25)
            background:setLooping(true)
            love.audio.play(background)
        end

        return background_function
end


function Menu.init(world)

    local input_system = world:getSystem(InputSystem)
    local asset_manager = world:getAssetManager()
    local em = world:getEntityManager()


    input_system:registerInput('up', Actions.MENU_UP)
    input_system:registerInput('down', Actions.MENU_DOWN)
    input_system:registerInput('return', Actions.MENU_SELECT)


    local menu = em:createEntity('menu')

    local menu_component = MenuGui(150, 150, world)

    local medium_font = asset_manager:getFont(Assets.FONT_MEDIUM)
    menu_component:setTextColor(204, 147, 147, 255)
    menu_component:setHighlightColor(147,176,204, 255)
    menu_component:setFont(medium_font, 18)
    
    menu_component:addMenuItem("CloudsForm", sceneChanger("CloudsForm"), backgroundPlayer("CloudsForm"))
    menu_component:addMenuItem("LightningRiskedItAll", sceneChanger("LightningRiskedItAll"), backgroundPlayer("LightningRiskedItAll"))
    menu_component:addMenuItem("ColorsShifting", sceneChanger("ColorsShifting"), backgroundPlayer("ColorsShifting"))
    menu_component:addMenuItem("AsFireSweptCleanTheEarth", sceneChanger("AsFireSweptCleanTheEarth"), backgroundPlayer("AsFireSweptCleanTheEarth"))

    menu:addComponent(menu_component)

    menu:addComponent(InputResponse():addResponse(menuInputResponse))

    world:tagEntity(Tags.MENU, menu)
    world:addEntityToGroup(Tags.MENU_GROUP, menu)



end 

function menuInputResponse(menu, held_actions, pressed_actions, dt)


    local menu_component = menu:getComponent(MenuGui)

    if not menu_component.selected_index then
        menu_component.selected_index = 1
        menu_component:highlightMenuItem(menu_component.selected_index)
    end 

    if pressed_actions[Actions.MENU_UP] then

        menu_component.selected_index = menu_component.selected_index - 1
        menu_component:loopSelectedIndex()
        menu_component:highlightMenuItem(menu_component.selected_index)

    elseif pressed_actions[Actions.MENU_DOWN] then

        menu_component.selected_index = menu_component.selected_index + 1
        menu_component:loopSelectedIndex()
        menu_component:highlightMenuItem(menu_component.selected_index)

    elseif pressed_actions[Actions.MENU_SELECT] then

        menu_component:selectMenuItem(menu_component.selected_index)

        -- TODO: Special case to make sound play at beginning of menu entrance; just make this play
        -- at Menu:enter()
        menu_component.selected_index = nil

    end

end
    
return Menu