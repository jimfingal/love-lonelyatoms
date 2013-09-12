require 'external.middleclass'
require 'core.gamestate'
require 'core.input'
require 'core.entity.menu'
require 'assets.assets'
require 'core.entity.textbox'


 local stateChanger = function(song)

        local state_function = function (state_manager) state_manager:changeState(States.PLAY, song) end
        return state_function

end

local backgroundPlayer =  function(song)
        -- Hack -- read from con

        local filename = song .. "_background.mp3"
        
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

MenuState = class('Menu', GameState)

function MenuState:initialize(name, state_manager, asset_manager)

    GameState.initialize(self, name, state_manager, asset_manager)



    local large_font = asset_manager:getFont(Assets.FONT_LARGE)
    local medium_font = asset_manager:getFont(Assets.FONT_MEDIUM)
    local small_font = asset_manager:getFont(Assets.FONT_SMALL)

    self.menu = SimpleMenu(150, 150, 500, 300)

    self.menu:setBackgroundColor(60, 60, 60, 255)
    self.menu:setTextColor(204, 147, 147, 255)
    self.menu:setHighlightColor(147,176,204, 255)
    self.menu:setFont(medium_font, 18)
    

    -- TODO - don't hard code
    self.menu:addMenuItem("CloudsForm", stateChanger("CloudsForm"), backgroundPlayer("CloudsForm"))
    self.menu:addMenuItem("LightningRiskedItAll", stateChanger("LightningRiskedItAll"), backgroundPlayer("LightningRiskedItAll"))
    self.menu:addMenuItem("ColorsShifting", stateChanger("ColorsShifting"), backgroundPlayer("ColorsShifting"))
    self.menu:addMenuItem("AsFireSweptCleanTheEarth", stateChanger("AsFireSweptCleanTheEarth"), backgroundPlayer("AsFireSweptCleanTheEarth"))


    self.input = InputManager()
    self.input:registerInput('q', Actions.QUIT_GAME)

    self.background = RectangleShape(0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    self.background:setColor(63, 63, 63, 255)



    self.title = TextBox("E C H O B R E A K O U T", 25, 100)
    self.title:setColor(204,147,147)
    self.title:setFont(large_font)

    self.credits1 = TextBox("Press Enter to Select Level", 60, 500)
    self.credits2 = TextBox("by @BDFife and @JimFingal", 60, 530)

    self.credits1:setColor(204,147,147)
    self.credits2:setColor(204,147,147)

    self.credits1:setFont(small_font)
    self.credits2:setFont(small_font)



    -- TODO color scheme manager.
    
end




function MenuState:enter()
    -- love.audio.stop()
    self.menu:highlightMenuItem(self.menu.selected_index)
end



function MenuState:update(dt)

    -- Quit
    if self.input:newAction(Actions.QUIT_GAME) then
        love.event.push("quit")
    end

    self.menu:update(dt, state_manager)

end


function MenuState:draw()

    -- self.background:draw()
    -- Don't want to overwrite auto-game
    love.graphics.setBackgroundColor(63, 63, 63, 255)


    self.title:draw()

    self.menu:draw()
  
    self.credits1:draw()
    self.credits2:draw()
   
end

