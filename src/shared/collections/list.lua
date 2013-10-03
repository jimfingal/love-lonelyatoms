require 'external.middleclass'

List = class('List')

function List:initialize(initial)
	self.list = {}

	if initial then
		for k, l in ipairs(initial) do 
			self.list[k] = l 
		end
	end
end

function List:prepend(element)
	table.insert(self.list, 1, element)
end

function List:append(element)
	table.insert(self.list, element)
end

function List:popLeft()
	local left = self.list[1]
	table.remove(self.list, 1)
	return left
end

function List:popRight()
	local right = self.list[#self.list]
	table.remove(self.list, #self.list)
	return right
end


-- Removes an item the first time it appears
function List:removeFirst(element)
	for i, item in ipairs(self.list) do
        if item == element then
            table.remove(self.list, i)
            return
        end
    end
end

function List:contains(element)
	for i, item in ipairs(self.list) do
        if item == element then
            return true
        end
    end

    return false
end

function List:members()
	return ipairs(self.list)
end

function List:insertAt(index, object)
	self.list[index] = object
end


function List:memberAt(index)
	return self.list[index]
end

function List:size()
	return #self.list
end

function List:clear()
	for i in self:members() do
		self.list[i] = nil
	end
end

function List:__tostring()

	local l = {} -- List of elements
	for _, e in pairs(self.list) do
		l[#l + 1] = tostring(e)
	end
	return "LIST [" .. table.concat(l, ", ") .. "]"

end
