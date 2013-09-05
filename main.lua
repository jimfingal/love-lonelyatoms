require "gamestatemanager"
require "gamestate"
require 'assetmanager'
require 'gameconstants'

function love.load()

  window = { width = love.graphics.getWidth(),
               height = love.graphics.getHeight(),
               x = 0,
               y = 0,
               origin = 0 }

  state_manager = GameStateManager()

  asset_manager = AssetManager("/assets/fonts/", "/assets/sounds/", "/assets/images/")

  local splash_state = GameState(States.SPLASH, state_manager, asset_manager)
  state_manager:registerState(splash_state)

  local menu_state = GameState(States.MENU, state_manager, asset_manager)
  state_manager:registerState(menu_state)

  local game_state = GameState(States.PLAY, state_manager, asset_manager)
  state_manager:registerState(game_state)

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
