require 'external.middleclass'

GameStateManager = class("GameStateManager")

function GameStateManager:initialize()
	self.last_state = nil
	self.current_state = nil
	self.states = {}
end


function GameStateManager:registerState(this_state)
	assert(this_state, "Missing argument: Gamestate to register")
	self.states[this_state:getName()] = this_state
end

function GameStateManager:printStates()
	local l = {}
	for e in pairs(self.states) do
		l[#l + 1] = e
	end
	print("{" .. table.concat(l, ", ") .. "}")
end

function GameStateManager:changeState(to_name, ...)
	assert(to_name, "Missing argument: Gamestate to switch to")
	assert(self:stateExists(to_name), "State must exist")
	self.last_state = self.current_state
	self.current_state = self.states[to_name]
	self.current_state:enter(...)
	return to
end

function GameStateManager:stateExists(name)
	return self.states[name]
end

function GameStateManager:currentState()
	return self.current_state
end

-- Callbacks to forward

function GameStateManager:update(dt)
	self.current_state:update(dt)
end

function GameStateManager:draw()
	self.current_state:draw()
end