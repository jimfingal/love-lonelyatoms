require "engine.gamestatemanager"
require "engine.gamestate"
require 'engine.assetmanager'
require 'gameconstants'

function love.load()

  window = { width = love.graphics.getWidth(),
               height = love.graphics.getHeight(),
               x = 0,
               y = 0,
               origin = 0 }

 	state_manager = GameStateManager()

	asset_manager = AssetManager("assets/fonts/", "assets/sounds/", "assets/images/")

  ps2p = "PressStart2P.ttf"
	asset_manager:loadFont(Assets.FONT_BIG, ps2p, 30)


  -- Splash State
	local splash_state = GameState(States.SPLASH, state_manager, asset_manager)
  
  splash_state.time = 0

  function splash_state:update(dt)

    self.time = self.time + dt

    if self.time > 2 then
      self:stateManager():changeState(States.MENU)
    end

  end


	function splash_state:draw()

		love.graphics.setColor(204,147,147)
		love.graphics.setFont(self:assetManager():getFont(Assets.FONT_BIG))
    menu_str = "SPLASH SCREEN"
    love.graphics.print(menu_str, 175, 100)
    menu_str = "STARTING IN " .. tostring(2 - self.time)
    love.graphics.print(menu_str, 175, 125)


	end


	state_manager:registerState(splash_state)


  -- Menu State
  local menu_state = GameState(States.MENU, state_manager, asset_manager)

  function menu_state:update(dt)

    if love.keyboard.isDown(" ") or love.keyboard.isDown("return") then
       self:stateManager():changeState(States.PLAY)
    end

  end

  function menu_state:draw()
		love.graphics.setColor(204,147,147)
		love.graphics.setFont(self:assetManager():getFont(Assets.FONT_BIG))
    menu_str = "MENU SCREEN"
    love.graphics.print(menu_str, 175, 100)
    menu_str = "Press Space to Play"
    love.graphics.print(menu_str, 175, 125)

	end

  state_manager:registerState(menu_state)


  -- Play State
  local game_state = GameState(States.PLAY, state_manager, asset_manager)

  function game_state:update(dt)

  end

  function game_state:draw()
    love.graphics.setColor(204,147,147)
    love.graphics.setFont(self:assetManager():getFont(Assets.FONT_BIG))
    menu_str = "PLAY SCREEN"
    love.graphics.print(menu_str, 175, 100)
  end


  state_manager:registerState(game_state)


  -- Initialize
  state_manager:changeState(States.SPLASH)

end

-- Perform computations, etc. between screen refreshes.
function love.update(dt)
  state_manager:update(dt)
end

-- Update the screen.
function love.draw()
  state_manager:draw()
end
