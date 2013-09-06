require 'class.middleclass'

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

function List:memberAt(index)
	return self.list[index]
end


function List:__tostring()
	return "{" .. table.concat(self.list, ", ") .. "}"
end
