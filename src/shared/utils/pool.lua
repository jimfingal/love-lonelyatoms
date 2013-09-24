require 'external.middleclass'
require 'collections.list'

Pool = class('Pool')

function Pool:initialize(object_creation_function, object_limit)

	-- A function which gets us an object. Generally a factory method or other initializer
	self.object_creation_function = object_creation_function or nil

	-- A function called on the object when we get it back from the recycler. Could re-initialize
	-- components, zero out values we want to reset, etc.
	self.object_reset_function = nil

	-- Limit of objects to have in the pool
	self.count_limit = object_limit or 0

	-- Objects currently in use
	self.used_objects = Set()
	self.used_count = 0

	-- Objects slated to be recycled
	self.recycled_objects = List()
	self.recycled_count = 0

end

function Pool:setObjectCreationFunction(object_creation_function)
	self.object_creation_function = object_creation_function
end

function Pool:setObjectResetFunction(object_reset_function)
	self.object_reset_function = object_reset_function
end

function Pool:setObjectLimit(num)
	self.count_limit = num
end

function Pool:initializeRemainingObjects()

	local count_to_make = self.count_limit - self.used_count - self.recycled_count

	for i = 1, count_to_make, 1 do

		local this_obj = self:create()
		self.recycled_objects:append(this_obj)
		self.recycled_count = self.recycled_count + 1

	end

end

-- Retrieves an object from pool. Tries recycled items first; if
-- there are none and we haven't reached our limit, create a new object.
-- If we have reached our limit, 
function Pool:getObject(...)

	-- If we have a recycled item, use that
	if self.recycled_count > 0 then

		local this_object = self.recycled_objects:popLeft()

		if self.object_reset_function then 
			self.object_reset_function(this_object, ...)
		end
	
		self.used_objects:add(this_object)
		self.used_count = 	self.used_count + 1
		self.recycled_count = self.recycled_count - 1

		return this_object
	
	-- Otherwise, if we haven't reached our limit, create a new one

	elseif self.used_count < self.count_limit then

		-- Create a new one
		local this_object = self:create(...)
		self.used_objects:add(this_object)

		self.used_count = 	self.used_count + 1

		return this_object

	-- Return nil if we've reached our limit and none to recycle
	else 
		return nil
	end

end


-- Create
function Pool:create(...)
	assert(self.object_creation_function, "Must have a function to get us an object")
	return self.object_creation_function(...)
end

-- Recycle
function Pool:recycle(object)
	-- Ensure object is either currently used, or not already recycled
	assert(self.used_objects:contains(object) or not self.recycled_objects:contains(object), "Object must either be used or not yet recycled: " .. tostring(object))

	self.used_objects:remove(object)
	self.recycled_objects:append(object)
	self.used_count = self.used_count - 1
	self.recycled_count = self.recycled_count + 1
end


function Pool:__tostring()
	return "Pool with function " .. tostring(self.object_creation_function) .. " [" ..
			"object reset function = " .. tostring(self.object_reset_function) ..
			"count_limit = " .. self.count_limit ..
			"; used_count = " .. self.used_count ..
			"; recycled_count = " .. self.recycled_count ..
			"; used_objects = " .. tostring(self.used_objects) ..
			"; recycled_objects = " .. tostring(self.recycled_objects) ..
			"]"
end
