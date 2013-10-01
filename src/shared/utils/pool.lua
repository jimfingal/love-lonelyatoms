require 'external.middleclass'
require 'collections.list'

Pool = class('Pool')

function Pool:initialize(pool_source, object_limit)

	self.pool_source = pool_source

	-- Limit of objects to have in the pool
	self.count_limit = object_limit or 0

	-- Objects currently in use
	self.used_objects = Set()
	self.used_count = 0

	-- Objects slated to be recycled
	self.recycled_objects = List()
	self.recycled_count = 0

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

		return self:getRecycledObject(...)
	
	-- Otherwise, if we haven't reached our limit, create a new one

	elseif self.used_count < self.count_limit then

		return self:createNewObject(...)

	-- Return nil if we've reached our limit and none to recycle
	else 
		return nil
	end

end


function Pool:createNewObject(...)
	
	-- Create a new one
	local this_object = self:create(...)
	self.used_objects:add(this_object)

	self.used_count = 	self.used_count + 1

	return this_object
end

function Pool:getRecycledObject(...)
	
	local this_object = self.recycled_objects:popLeft()

	self:reset(this_object, ...)
	self.used_objects:add(this_object)
	self.used_count = self.used_count + 1
	self.recycled_count = self.recycled_count - 1

	return this_object

end


-- Create
function Pool:create(...)
	return self.pool_source:create(...)
end

-- Reset
function Pool:reset(object, ...)
	self.pool_source:reset(object, ...)
end

-- Recycle
function Pool:recycle(object, ...)
	-- Ensure object is either currently used, or not already recycled
	assert(self.used_objects:contains(object) or not self.recycled_objects:contains(object), "Object must either be used or not yet recycled: " .. tostring(object))

	self.pool_source:recycle(object, ...)
	self.used_objects:remove(object)
	self.recycled_objects:append(object)
	self.used_count = self.used_count - 1
	self.recycled_count = self.recycled_count + 1
end


function Pool:__tostring()
	return "Pool with [count_limit = " .. self.count_limit ..
			"; used_count = " .. self.used_count ..
			"; recycled_count = " .. self.recycled_count ..
			"; used_objects = " .. tostring(self.used_objects) ..
			"; recycled_objects = " .. tostring(self.recycled_objects) ..
			"]"
end
