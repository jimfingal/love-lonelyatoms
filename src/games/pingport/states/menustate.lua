require 'external.middleclass'
require 'engine.gamestate'
require 'engine.input'
require 'engine.menu'
require 'assets.assets'




MenuState = class('Menu', GameState)

function MenuState:initialize(name, state_manager, asset_manager)

    GameState.initialize(self, name, state_manager, asset_manager)

    self.menu = SimpleMenu(150, 150, 500, 300)

    self.menu:setBackgroundColor(60, 60, 60, 255)
    self.menu:setTextColor(204, 147, 147, 255)
    self.menu:setHighlightColor(147,176,204, 255)
    
    self.menu:setFont(asset_manager:getFont(Assets.FONT_MEDIUM), 18)

    -- TODO
    self.menu:addMenuItem("Menu Item 1", function (state_manager) state_manager:changeState(States.PLAY) end)
    self.menu:addMenuItem("Menu Item 2", function (state_manager) state_manager:changeState(States.PLAY) end)
    self.menu:addMenuItem("Menu Item 3", function (state_manager) state_manager:changeState(States.PLAY) end)


    self.input = InputManager()
    self.input:registerInput('q', Actions.QUIT_GAME)

end


function MenuState:update(dt)


    -- Quit
    if self.input:newAction(Actions.QUIT_GAME) then
        love.event.push("quit")
    end

    self.menu:update(dt, state_manager)

end


function MenuState:draw()

    love.graphics.setBackgroundColor(63, 63, 63, 255)

    -- TODO color scheme manager.
	love.graphics.setColor(204,147,147)
	love.graphics.setFont(self:assetManager():getFont(Assets.FONT_LARGE))
    love.graphics.print("E C H O B R E A K O U T", 25, 100)

    self.menu:draw()
  
    love.graphics.setColor(204,147,147)
    love.graphics.setFont(self:assetManager():getFont(Assets.FONT_SMALL))
    love.graphics.print("Press Enter to Select Level", 60, 500)
    love.graphics.print("by @BDFife and @JimFingal", 60, 530)

   
end