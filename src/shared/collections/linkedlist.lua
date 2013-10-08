require 'external.middleclass'

LinkedList = class('LinkedList')

function LinkedList:initialize()
	self.list = {}
end

function LinkedList:prepend(value)
	
	local first = self:memberAt(1)

	local node = LinkedListNode(value)

	if first then
		first:setLeftLink(node)
		node:setRightLink(first)
	end

	table.insert(self.list, 1, node)
end

function LinkedList:append(value)

	local last = self:memberAt(self:size())

	local node = LinkedListNode(value)

	if last then 
		last:setRightLink(node)
		node:setLeftLink(last)
	end

	table.insert(self.list, node)
end

function LinkedList:popLeft()
	local left = self:memberAt(1)
	table.remove(self.list, 1)

	local first = self:memberAt(1)
	if first then 
		first:setLeftLink(nil)
	end

	return left
end

function LinkedList:popRight()
	local right = self:memberAt(self:size())
	table.remove(self.list, self:size())

	local last = self:memberAt(self:size())
	if last then 
		last:setRightLink(nil)
	end

	return right
end

function LinkedList:contains(element)
	for i, item in ipairs(self.list) do
        if item == element then
            return true
        end
    end

    return false
end

function LinkedList:containsValue(value)
	for i, item in ipairs(self.list) do
        if item:getValue() == value then
            return true
        end
    end

    return false
end

function LinkedList:members()
	return ipairs(self.list)
end

function LinkedList:memberAt(index)
	return self.list[index]
end

function LinkedList:size()
	return #self.list
end

function LinkedList:clear()
	for i in self:members() do
		self.list[i] = nil
	end
end

function LinkedList:__tostring()

	local l = {} -- List of elements
	for _, e in pairs(self.list) do
		l[#l + 1] = "Node: " .. tostring(e:getValue()) .. " Left Link: " .. tostring(e:getLeftLink()) .. " Right Link: " .. tostring(e:getRightLink())
	end
	return "LIST [" .. table.concat(l, ", ") .. "]"

end


LinkedListNode = class('LinkedListNode')

function LinkedListNode:initialize(value)

	self.value = value
	self.left = nil
	self.right = nil

end

function LinkedListNode:setLeftLink(left)
	self.left = left
	return self
end

function LinkedListNode:getLeftLink()
	return self.left
end

function LinkedListNode:setRightLink(right)
	self.right = right
	return self
end

function LinkedListNode:getRightLink()
	return self.right
end


function LinkedListNode:setValue(value)
	self.value = value
	return self
end

function LinkedListNode:getValue()
	return self.value
end

