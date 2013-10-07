require 'external.middleclass'
require 'collections.matrix'
require 'utils.counters'


CellularGrid = class('CellularGrid')

function CellularGrid:initialize(x, y)

	self.grid = Matrix(x, y, nil)

	self.frame = Counter()

	self:reset()

end

function CellularGrid:reset()

	self.frame = Counter()

	for i = 1, self.grid:rowCount() do
		for j = 1, self.grid:columnCount() do
			self.grid:put(i, j, CellularAutomata())
		end
	end

end

function CellularGrid:updateFrame()
	self.frame:increment()
end

function CellularGrid:getCell(x, y)
	return self.grid:get(x, y)
end

CellularAutomata = class('CellularAutomata')

function CellularAutomata:initialize()
	self.active = false
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