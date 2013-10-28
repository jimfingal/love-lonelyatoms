require 'entity.components.transform'
require 'entity.components.rendering'
require 'entity.components.collider'
require 'entity.components.motion'
require 'entity.components.behavior'
require 'entity.components.inputresponse'
require 'entity.components.soundcomponent'

require 'enums.tags'
require 'enums.actions'
require 'collections.list'


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

        local required = 'assets.spritemaps.' .. song
        local config = require(required)
        local filename = config.background_snd

        --local filename = song .. "_background.mp3"
        
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
    

    local songs = List()
    songs:append("Ballpen_AnneLisaGoesToBed")
    songs:append("YouKillMyBrother_GoGoGo")
    songs:append("CrazyGames_WakeUp")

   
    for _, songname in songs:members() do 
        menu_component:addMenuItem(songname, sceneChanger(songname), backgroundPlayer(songname))
    end

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