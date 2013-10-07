require 'external.middleclass'


-- TODO: UNTESTED!
Matrix = class('Matrix')

function Matrix:initialize(rows, columns, default, strict)
	self.matrix = {}

	self.rows = rows
	self.columns = columns

	self.default = default

	self:clear()

	if self.default ~= nil then 
		self:populateDefault()
	end

	self.strict = strict or true

end

function Matrix:rowCount()
	return self.rows
end

function Matrix:columnCount()
	return self.columns
end

function Matrix:put(x, y, value)
	
	if self.strict then
		assert(x > 0, "X must be greater than zero, passed in " .. tostring(x))
		assert(x <= self.rows, "X must be less than or equal to  " .. tostring(self.rows) .. ", passed in " .. tostring(x))
		assert(y > 0, "Y must be greater than zero, passed in " .. tostring(y))
		assert(y <= self.columns, "Y must be less than or equal to " .. tostring(self.columns) .. ", passed in " .. tostring(y))
	end
	
	self.matrix[x][y] = value
	
	return self
end

function Matrix:get(x, y)
	
	if self.strict then
		assert(x > 0, "X must be greater than zero, passed in " .. tostring(x))
		assert(x <= self.rows, "X must be less than or equal to " .. tostring(self.rows) .. ", passed in " .. tostring(x))
	end

	return self.matrix[x][y]

end

function Matrix:clear()
	for i = 1, self.rows do
		self.matrix[i] = {}
	end
end

function Matrix:populateDefault()

	for i = 1, self.rows do
		for j = 1, self.columns do
			self.matrix[i][j] = self.default
		end
	end
end

function Matrix:__tostring()
	local s = "\n"

	for x = 1, self.rows do
		for y = 1, self.rows do
			s = s .. "[" .. tostring(self.matrix[x][y]) .."]"
		end
		s = s .."\n"
	end

	return s
end
