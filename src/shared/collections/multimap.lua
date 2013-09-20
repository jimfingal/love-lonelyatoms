require 'external.middleclass'
require 'collections.set'

MultiMap = class('MultiMap')

function MultiMap:initialize()
	self.map = {}
end

-- If no mappings in the multimap have the provided key, an empty set is returned.
function MultiMap:get(key)

	local values = self.map[key]

	if not values then
		values = Set()
		self.map[key] = values
	end

	return values
end

function MultiMap:put(key, value)
	
	local values = self:get(key)
	values:add(value)

end

function MultiMap:putAll(key, value)
	
	local values = self:get(key)
	values:addSet(value)

end

function MultiMap:containsKey(key)
	return self.map[key]
end

function MultiMap:remove(key, value)
	local values = self:get(key)
	values:remove(value)
	if values:size() == 0 then
		self.map[key] = nil
	end
end

function MultiMap:keys()
	local keyset = Set()
	for key, _ in pairs(self.map) do
		keyset:add(key)
	end
	return keyset
end

function MultiMap:values()
	local valueset = Set()
	for _, value in pairs(self.map) do
		valueset:addSet(value)
	end
	return valueset
end

function MultiMap:clear()
	self.map = {}
end

function MultiMap:__tostring()
	local l = {} -- List of elements
	for key, value in pairs(self.map) do
		l[#l + 1] = "key: " .. tostring(key) .. " :: value: " .. tostring(value)
	end
	return "MultiMap [" .. table.concat(l, ", ") .. "]"
end
