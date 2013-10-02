require 'external.middleclass'


-- TODO: UNTESTED!
Matrix = class('Matrix')

function Matrix:initialize(rows, columns, value)
	self.matrix = {}

	self.rows = rows
	self.columns = columns

	for i = 1,rows do
		self.matrix[i] = {}
		for j = 1,columns do
			self.matrix[i][j] = value
		end
	end
end

function Matrix:put(x, y)
	assert(x > 0, "X must be greater than zero, passed in " .. tostring(x))
	assert(x < self.rows, "X must be less than  " .. tostring(self.rows) .. ", passed in " .. tostring(x))
	assert(y > 0, "Y must be greater than zero, passed in " .. tostring(y))
	assert(y < self.columns, "Y must be less than  " .. tostring(self.columns) .. ", passed in " .. tostring(y))

end

function Matrix:get(x, y)
	assert(x > 0, "X must be greater than zero, passed in " .. tostring(x))
	assert(x < self.rows, "X must be less than  " .. tostring(self.rows) .. ", passed in " .. tostring(x))
	return self.matrix[x][y]
end

function Matrix:clear()
	for key in pairs(self.matrix) do
		self.matrix[key] = nil
	end
end

function Matrix:__tostring()
	-- TODO
end
