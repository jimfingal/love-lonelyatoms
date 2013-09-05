require 'class.middleclass'
require 'engine.gamestate'
require 'assets.assets'

SplashState = class('Splash', GameState)

function SplashState:initialize(name, state_manager, asset_manager)

    GameState.initialize(self, name, state_manager, asset_manager)

    self.timer = 2


end


function SplashState:update(dt)

    self.timer = self.timer - dt

    if self.timer < 0.001 then
      self:stateManager():changeState(States.MENU)
    end

    if love.keyboard.isDown(" ") or love.keyboard.isDown("return") then
       self:stateManager():changeState(States.PLAY)
    end

end


function SplashState:draw()

    love.graphics.setBackgroundColor(63, 63, 63, 255)

	love.graphics.setColor(204,147,147)
	love.graphics.setFont(self:assetManager():getFont(Assets.FONT_LARGE))
    menu_str = "SPLASH SCREEN"
    love.graphics.print(menu_str, 175, 100)

    love.graphics.setFont(self:assetManager():getFont(Assets.FONT_SMALL))
    menu_str = "STARTING IN " .. tostring(self.timer)
    love.graphics.print(menu_str, 200, 125)

end