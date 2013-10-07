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

			assert(cell, "Must be a cell but no cell at " .. tostring(i) .. " , " .. tostring(j) .. " for grid " .. tostring(self.grid))
			self:setNeighbors(cell)
		end
	end

end

function CellularGrid:updateFrame()
	self.frame:increment()
end

function CellularGrid:getCell(x, y)

	if x < 1 or x > self:rowCount() or y < 1 or y > self:columnCount() then
		return nil
	else
		return self.grid:get(x, y)
	end
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

			local nx = cell.position.x + i
			local ny = cell.position.y + j

			if nx ~= 0 and ny ~= 0 then
				
				local neighbor = self:getCell(nx, ny)

				if neighbor then
					cell.neighbors:append(neighbor)
				end

			end

		end
	end
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

function CellularAutomata:invertState()
	self.active = not self.active
end

function CellularAutomata:__tostring()
	local s = "CA at " .. tostring(self.position)
	
	s = s .. ",\nneighbors at: "
	for i, neighbor in self.neighbors:members() do
		if i > 1 then
			s = s .. ", "
		end
		s = s .. tostring(neighbor.position) .. "\n"
	end

	return s
end
