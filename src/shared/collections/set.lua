require 'external.middleclass'
require 'socket'

Set = class('Set')

Set.EMPTY_SET = Set()

function Set:initialize(list)

	self.set = {}

	if list then
		for _, l in ipairs(list) do 
			self.set[l] = true 
		end
	end
end

-- Clones the set, but not the members within
function Set:clone()
	local clone = Set()
	for member in self:members() do
		clone:add(member)
	end
	return clone
end

function Set:add(element)
	self.set[element] = true
end

function Set:addSet(other_set)
	for element in other_set:members() do 
		self:add(element) 
	end
end

function Set:remove(element)
	self.set[element] = nil
end

function Set:contains(element)
	return self.set[element]
end

function Set:size()
	local count = 0
	for member in self:members() do
		count = count + 1
	end
	return count
end

function Set:members()
	return pairs(self.set)
end


function Set.union(a, b)

	if not a then return b end
	if not b then return a end

    local union = Set()

    for k in a:members() do union:add(k) end    
    for k in b:members() do union:add(k) end
        
    return union
 end
    
function Set:intersection(b)

	local intersection = Set()

	if (not b) then return intersection end

  	for k in self:members() do
  		intersection.set[k] = b.set[k]
    end
    
    return intersection
end

function Set:clear()
	for member in self:members() do
		self:remove(member)
	end
end

function Set:__tostring()
	local l = {} -- List of elements
	for e in pairs(self.set) do
		l[#l + 1] = tostring(e)
	end
	return "SET [" .. table.concat(l, ", ") .. "]"
end
