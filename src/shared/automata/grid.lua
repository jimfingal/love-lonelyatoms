require 'external.middleclass'
require 'collections.matrix'
require 'utils.counters'
require 'collections.list'
require 'core.vector'
require 'automata.cell'

CellGrid = class('CellGrid')

function CellGrid:initialize(x, y, cellFactory)

	self.grid = Matrix(x, y, nil)

	self.frame = Counter()

	self.makeCell = cellFactory

end

function CellGrid:init()


	self.frame = Counter()

	for x = 1, self.grid:rowCount() do
		for y = 1, self.grid:columnCount() do

			self.grid:put(x, y, self.makeCell(x, y))
		end
	end


	for i = 1, self.grid:rowCount() do
		for j = 1, self.grid:columnCount() do
			local cell = self:getCell(i, j)
			self:initializeNeigborLinks(cell)
		end
	end

end

function CellGrid:getCell(x, y)


	if x < 1 or x > self:rowCount() or y < 1 or y > self:columnCount() then
		return nil
	else
		return self.grid:get(x, y)
	end
end

function CellGrid:frameNumber()
	return self.frame:value()
end


function CellGrid:rowCount()
	return self.grid:rowCount()
end

function CellGrid:columnCount()
	return self.grid:columnCount()
end

function CellGrid:initializeNeigborLinks(cell)


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

function CellGrid:__tostring()
	local s = "CellularGrid with matrix " .. tostring(self.grid)
	return s
end
