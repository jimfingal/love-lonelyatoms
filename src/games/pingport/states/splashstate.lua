require 'external.middleclass'
require 'engine.gamestate'
require 'assets.assets'
require 'engine.input'
require 'states.actions'

SplashState = class('Splash', GameState)

function SplashState:initialize(name, state_manager, asset_manager)

    GameState.initialize(self, name, state_manager, asset_manager)

    self.timer = 2

    self.input = InputManager()

    self.input:registerInput(' ', Actions.SKIP_SPLASH)
    self.input:registerInput('return', Actions.SKIP_SPLASH)

end


function SplashState:update(dt)

    self.input:update(dt)

    self.timer = self.timer - dt

    if self.timer < 0.001 then
      self:stateManager():changeState(States.MENU)
    end

    if self.input:newAction(Actions.SKIP_SPLASH) then
       self:stateManager():changeState(States.MENU)
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