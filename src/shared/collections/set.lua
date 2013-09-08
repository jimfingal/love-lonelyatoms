require 'external.middleclass'

Set = class('Set')

function Set:initialize(list)
	self.set = {}
	for _, l in ipairs(list) do 
		self.set[l] = true 
	end
end

function Set:add(element)
	self.set[element] = true
end

function Set:remove(element)
	self.set[element] = nil
end

function Set:contains(element)
	return self.set[element]
end

function Set:__tostring()
	local l = {} -- List of elements
	for e in pairs(self.set) do
		l[#l + 1] = e
	end
	return "{" .. table.concat(l, ", ") .. "}"
end
