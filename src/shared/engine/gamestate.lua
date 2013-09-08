require 'external.middleclass'

GameState = class('GameState')

function GameState:initialize(name, state_manager, asset_manager)
  assert(name, "must have a name")
  assert(state_manager, "must have a state manager")
  assert(asset_manager, "must have an asset manager")
  self.name = name
  self.state_manager = state_manager
  self.asset_manager = asset_manager
end


function GameState:enter()
    -- setup entities here
    print("Calling setup method of state: " .. self.name)
end

function GameState:draw()
	-- draw all entities
	print("Calling draw method of state: " .. self.name)
end

function GameState:update(dt)
    -- update all entities
    print("Calling update method of state: " .. self.name)

end

function GameState:getName()
    -- update all entities
    return self.name
end

function GameState:stateManager()
    -- update all entities
    return self.state_manager
end

function GameState:assetManager()
    -- update all entities
    return self.asset_manager
end