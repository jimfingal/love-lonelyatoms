require 'external.middleclass'
require 'collections.matrix'
require 'utils.counters'
require 'collections.list'
require 'core.vector'


CellularGrid = class('CellularGrid')

function CellularGrid:initialize(x, y)

	self.grid = Matrix(x, y, nil)

	self.frame = Counter()

	self:reset()

end

function CellularGrid:reset()

	self.frame = Counter()

	for x = 1, self.grid:rowCount() do
		for y = 1, self.grid:columnCount() do
			self.grid:put(x, y, CellularAutomata(x, y))
		end
	end


	for i = 1, self.grid:rowCount() do
		for j = 1, self.grid:columnCount() do
			local cell = self:getCell(i, j)
			self:setNeighbors(cell)
		end
	end

end

function CellularGrid:updateFrame()
	self.frame:increment()

	for x = 1, self.grid:rowCount() do
		for y = 1, self.grid:columnCount() do
			
			local cell = self:getCell(x, y)
			local current_state = cell:isOn()
			local neighbor_count = cell:countNeighbors()

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

function CellularGrid:getCell(x, y)

	if x < 1 or x > self:rowCount() or y < 1 or y > self:columnCount() then
		return nil
	else
		return self.grid:get(x, y)
	end
end

function CellularGrid:frameNumber()
	return self.frame:value()
end


function CellularGrid:rowCount()
	return self.grid:rowCount()
end

function CellularGrid:columnCount()
	return self.grid:columnCount()
end


function CellularGrid:setNeighbors(cell)


	for i = -1, 1 do
		for j = -1, 1 do

			if not (i == 0 and j == 0) then
				local nx = cell.position.x + i
				local ny = cell.position.y + j

				local neighbor = self:getCell(nx, ny)

				if neighbor then
					cell.neighbors:append(neighbor)
				end
			end

		end
	end
end

function CellularGrid:birthCondition(neighbor_count)
	return neighbor_count == 3
end

function CellularGrid:deathCondition(neighbor_count)
	return neighbor_count <=1 or neighbor_count >= 4
end

function CellularGrid:stasisCondition(neighbor_count)
	return neighbor_count == 3 or neighbor_count == 2
end

function CellularGrid:__tostring()
	local s = "CellularGrid with matrix " .. tostring(self.grid)
	return s
end

CellularAutomata = class('CellularAutomata')

function CellularAutomata:initialize(x, y)
	self.active = false
	self.position = Vector(x, y)
	self.neighbors = List()
	self.next_state = nil
end

function CellularAutomata:setNextState(next_state)
	self.next_state = next_state
end

function CellularAutomata:transitionState()
	self.active = self.next_state
end

function CellularAutomata:isOn()
	return self.active
end

function CellularAutomata:setOn()
	self.active = true
end

function CellularAutomata:setOff()
	self.active = false
end

function CellularAutomata:countNeighbors()

	local count = 0

	for i, neighbor in self.neighbors:members() do
		
		if neighbor:isOn() then 
			count = count + 1 
		end

	end

	return count
end

function CellularAutomata:invertState()
	self.active = not self.active
end

function CellularAutomata:__tostring()
	local s = "CA at " .. tostring(self.position) .. " with value " .. tostring(self:isOn())
	
	s = s .. ",\nneighbors at: "
	for i, neighbor in self.neighbors:members() do
		if i > 1 then
			s = s .. ", "
		end
		s = s .. tostring(neighbor.position) .. tostring(neighbor:isOn()) .. "\n"
	end

	return s
end
