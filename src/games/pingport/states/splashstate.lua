require 'external.middleclass'
require 'engine.gamestate'
require 'assets.assets'
require 'engine.input'
require 'states.actions'
require 'engine.animation'

SplashState = class('Splash', GameState)

function SplashState:initialize(name, state_manager, asset_manager)

    GameState.initialize(self, name, state_manager, asset_manager)

    self.input = InputManager()

    self.input:registerInput(' ', Actions.SKIP_SPLASH)
    self.input:registerInput('return', Actions.SKIP_SPLASH)

    self.asset_manager:loadSound(Assets.LETTER_SOUND, "letter.wav")
    local typing_sound = self.asset_manager:getSound(Assets.LETTER_SOUND)
    
    local play_sound = function() 
        typing_sound:setVolume(0.5)
        love.audio.play(typing_sound)
        love.audio.rewind(typing_sound)
    end


    self.splash_text = TextAnimation("E C H O B R E A K O U T", 0.125, false, play_sound)

    -- self.timer = 5

    self.debug = false

    self.splash_text:play()
end


function SplashState:update(dt)

    self.input:update(dt)
    self.splash_text:update(dt)

    -- self.timer = self.timer - dt

    
    if self.splash_text.status == Animation.PAUSED then
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

    self.splash_text:draw(25, 100)

  


    if self.debug then

        --[[
        menu_str = "STARTING IN " .. tostring(self.timer)
        love.graphics.print(menu_str, 200, 125)
        ]]

        love.graphics.setFont(self:assetManager():getFont(Assets.FONT_SMALL))

        menu_str = "Splash timer: " .. tostring(self.splash_text.timer)
        love.graphics.print(menu_str, 200, 150)

        menu_str = "Splash position: " .. tostring(self.splash_text.position)
        love.graphics.print(menu_str, 200, 175)

    end

end