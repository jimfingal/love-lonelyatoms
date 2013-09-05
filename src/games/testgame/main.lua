require "engine.gamestatemanager"
require "engine.gamestate"
require 'engine.assetmanager'
require 'states.states'
require 'states.splashstate'
require 'states.menustate'
require 'states.playstate'

require 'assets.assets'

function love.load()

  window = { width = love.graphics.getWidth(),
               height = love.graphics.getHeight(),
               x = 0,
               y = 0,
               origin = 0 }

 	state_manager = GameStateManager()

	asset_manager = AssetManager("assets/fonts/", "assets/sounds/", "assets/images/")

  ps2p = "PressStart2P.ttf"
	asset_manager:loadFont(Assets.FONT_LARGE, ps2p, 30)
  asset_manager:loadFont(Assets.FONT_MEDIUM, ps2p, 18)
  asset_manager:loadFont(Assets.FONT_SMALL, ps2p, 14)


  -- Splash State
	local splash_state = SplashState(States.SPLASH, state_manager, asset_manager)
	state_manager:registerState(splash_state)

  -- Menu State
  local menu_state = MenuState(States.MENU, state_manager, asset_manager)
  state_manager:registerState(menu_state)

  -- Play State
  local game_state = PlayState(States.PLAY, state_manager, asset_manager)
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
