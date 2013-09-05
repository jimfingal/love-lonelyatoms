require "engine.gamestatemanager"
require 'engine.assetmanager'
require 'assets'
require 'states'

function love.load()

  window = { width = love.graphics.getWidth(),
               height = love.graphics.getHeight(),
               x = 0,
               y = 0,
               origin = 0 }

  state_manager = GameStateManager()

  asset_manager = AssetManager("/assets/fonts/", "/assets/sounds/", "/assets/images/")

end

-- Perform computations, etc. between screen refreshes.
function love.update(dt)
  state_manager:update(dt)
end

-- Update the screen.
function love.draw()
  state_manager:draw()
end
