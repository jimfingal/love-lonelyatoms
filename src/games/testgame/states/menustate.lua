require 'class.middleclass'
require 'engine.gamestate'

MenuState = class('Menu', GameState)

function MenuState:initialize(name, state_manager, asset_manager)

    GameState.initialize(self, name, state_manager, asset_manager)

end


function MenuState:update(dt)

    if love.keyboard.isDown(" ") or love.keyboard.isDown("return") then
       self:stateManager():changeState(States.PLAY)
    end

end


function MenuState:draw()

    love.graphics.setBackgroundColor(63, 63, 63, 255)

	love.graphics.setColor(204,147,147)
	love.graphics.setFont(self:assetManager():getFont(Assets.FONT_LARGE))
    menu_str = "MENU SCREEN"
    love.graphics.print(menu_str, 175, 100)

    love.graphics.setFont(self:assetManager():getFont(Assets.FONT_SMALL))
    menu_str = "Press Space to Play"
    love.graphics.print(menu_str, 200, 150)

end