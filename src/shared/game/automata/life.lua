require 'external.middleclass'
require 'collections.matrix'
require 'util.counters'
require 'collections.list'
require 'math.vector2'

require 'game.automata.cell'
require 'game.automata.grid'


LifeGrid = class('LifeGrid', CellGrid)

local cellFactory = function(x, y)
	return LifeCell:new(x, y)
end

function LifeGrid:initialize(x, y)

	CellGrid.initialize(self, x, y, cellFactory)

	self:init()

end


function LifeGrid:updateFrame()
	self.frame:increment()

	for x = 1, self.grid:rowCount() do
		for y = 1, self.grid:columnCount() do
			
			local cell = self:getCell(x, y)
			local neighbor_count = cell:countNeighbors()
			local current_state = cell:getState()

			if self:birthCondition(neighbor_count) then

				cell:setNextState(true)
			
			elseif self:deathCondition(neighbor_count) then
			
				cell:setNextState(false)
			
			elseif self:stasisCondition(neighbor_count) then

				cell:setNextState(current_state)

			end

		end
	end

	for x = 1, self.grid:rowCount() do
		for y = 1, self.grid:columnCount() do
			
			local cell = self:getCell(x, y)
			cell:transitionState()

		end
	end

end

function LifeGrid:birthCondition(neighbor_count)
	return neighbor_count == 3
end

function LifeGrid:deathCondition(neighbor_count)
	return neighbor_count <=1 or neighbor_count >= 4
end

function LifeGrid:stasisCondition(neighbor_count)
	return neighbor_count == 3 or neighbor_count == 2
end

function LifeGrid:__tostring()
	local s = "LifeGrid with matrix " .. tostring(self.grid)
	return s
end

LifeCell = class('LifeCell', Cell)

function LifeCell:initialize(x, y)
	Cell.initialize(self, x, y, false)
end

function LifeCell:invertState()
	local new_state = false
	if self:getState() == false then
		new_state = true
	end
	self:setState(new_state)
	return self
end

function LifeCell:countNeighbors()

	local count = 0

	for i, neighbor in self.neighbors:members() do
		
		if neighbor:getState() == true then 
			count = count + 1 
		end

	end

	return count
end
