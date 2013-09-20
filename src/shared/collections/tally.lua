require 'external.middleclass'
require 'collections.set'

Tally = class('Tally')

function Tally:initialize()
	self.tally = {}
end

-- get count

function Tally:getCount(key)

	local current = self.tally[key]

	if not current then
		current = 0
		self.tally[key] = current
	end

	return current

end

function Tally:increment(key)

	local current = self:getCount(key)
	self.tally[key] = current + 1
end

function Tally:add(key, value)

	assert(type(value) == 'number', "value must be a number")
	local current = self:getCount(key)
	self.tally[key] = current + value
end
-- add


function Tally:reset(key)
	self.tally[key] = 0
end


function Tally:clear()
	self.tally = {}
end

function Tally:__tostring()
	local l = {} -- List of elements
	for key, value in pairs(self.tally) do
		l[#l + 1] = "key: " .. tostring(key) .. " :: value: " .. tostring(value)
	end
	return "Tally [" .. table.concat(l, ", ") .. "]"
end
