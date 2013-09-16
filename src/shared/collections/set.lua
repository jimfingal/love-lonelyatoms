require 'external.middleclass'

Set = class('Set')

function Set:initialize(list)
	self.set = {}

	if list then
		for _, l in ipairs(list) do 
			self.set[l] = true 
		end
	end
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
	return #self.set
end

function Set:members()
	return pairs(self.set)
end

function Set:union(b)
    local union = Set()

    for k in self:members() do union:add(k) end    
    for k in b:members() do union:add(k) end
        
    return union
 end
    
function Set:intersection(b)

	local intersection = Set()
  	
  	for k in self:members() do
  		intersection.set[k] = b.set[k]
    end
    
    return intersection
end



function Set:__tostring()
	local l = {} -- List of elements
	for e in pairs(self.set) do
		l[#l + 1] = tostring(e)
	end
	return "SET [" .. table.concat(l, ", ") .. "]"
end
