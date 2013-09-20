require 'external.middleclass'
require 'collections.list'

Pool = class('Pool')

function Pool:initialize(object_class, object_limit)

	self.object_class = object_class
	self.count_limit = object_limit

	self.used_objects = Set()
	self.recycled_objects = List()

	self.used_count = 0
	self.recycled_count = 0

end

function Pool:setObjectClass(object_class)
	self.object_class = object_class
end

function Pool:setObjectLimit(num)
	self.count_limit = num
end

function Pool:initializeRemainingObjects()

	local count_to_make = self.count_limit - self.used_count - self.recycled_count

	for i = 0, count_to_make, 1 do

		local this_obj = self:create()
		self.recycled_objects:append(this_obj)
		self.recycled_count = self.recycled_count + 1

	end

end

-- Retrieves an object from pool. Tries recycled items first; if
-- there are none and we haven't reached our limit, create a new object.
-- If we have reached our limit, 
function Pool:getObject()

	-- If we have a recycled item, use that
	if self.recycled_count > 0 then

		local this_object = self.recycled_objects:popLeft()
	
		self.used_objects:add(this_object)
		self.used_count = 	self.used_count + 1
		self.recycled_count = self.recycled_count - 1

		return this_object
	
	-- Otherwise, if we haven't reached our limit, create a new one

	elseif self.used_count < self.count_limit then

		-- Create a new one
		local this_object = self:create()
		self.used_objects:add(this_object)

		self.used_count = 	self.used_count + 1
		return this_object

	-- Return nil if we've reached our limit and none to recycle
	else 
		return nil
	end

end


-- Create
function Pool:create()
	assert(self.object_class, "Must set an object to be able to create new object")
	return self.object_class:new()
end

-- Recycle
function Pool:recycle(object)

	self.used_objects:remove(object)
	self.recycled_objects:append(object)

	self.used_count = self.used_count - 1
	self.recycled_count = self.free_count + 1
end


function Pool:__tostring()
	return "Pool of " .. tostring(self.object_class) .. "[" ..
			"count_limit = " .. self.count_limit ..
			"; used_count = " .. self.used_count ..
			"; recycled_count = " .. self.recycled_count ..
			"; used_objects = " .. self.used_objects ..
			"; recycled_objects = " .. self.recycled_objects ..
			"]"
end
