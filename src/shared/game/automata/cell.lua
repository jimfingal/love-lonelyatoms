require 'external.middleclass'
require 'collections.matrix'
require 'util.counters'
require 'collections.list'
require 'math.vector2'



Cell = class('Cell')

function Cell:initialize(x, y, default_state)
	assert(type(x) == "number", "X must be numeric but is instead " .. tostring(x))
	assert(type(y) == "number", "Y must be numeric but is instead " .. tostring(y))

	self.state = default_state
	self.position = Vector2(x, y)
	self.neighbors = List()
	self.next_state = default_state
end

function Cell:setNextState(next_state)
	self.next_state = next_state
end

function Cell:transitionState()
	self.state = self.next_state
end

function Cell:getState()
	return self.state
end

function Cell:setState(new_state)
	self.state = new_state
end


function Cell:__tostring()
	local s = "CA at " .. tostring(self.position) .. " with value " .. tostring(self:getState())
	
	s = s .. ",\nneighbors at: "
	for i, neighbor in self.neighbors:members() do
		if i > 1 then
			s = s .. ", "
		end
		s = s .. tostring(neighbor.position) .. tostring(neighbor:getState()) .. "\n"
	end

	return s
end
