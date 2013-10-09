require 'external.middleclass'
require 'math.quad.aabb'
require 'collections.set'
require 'collections.list'

QuadTree = class('QuadTree')

QuadTree.DEFAULT_MAX_OBJECTS = 10
QuadTree.DEFAULT_MAX_LEVEL = 5
QuadTree.CHILD_NODES = 4
QuadTree.CHILD_NODE_SQRT = 2

QuadTree.NW = 1
QuadTree.NE = 2
QuadTree.SW = 3
QuadTree.SE = 4
QuadTree.PARENT = -1


-- Every element is contained in the smallest quadtree node which contains it fully.
function QuadTree:initialize(aabb, level, max_objects, max_level)

	assert(aabb, "Must have an aabb")
	assert(level, "Must have a level")

	self.aabb = aabb

	self.boundary = nil -- AABB of boundary

	self.child_nodes = List()

	self.objects = Set()

	self.level = level

	self.max_objects = max_objects or QuadTree.DEFAULT_MAX_OBJECTS
	self.max_level = max_level or QuadTree.DEFAULT_MAX_LEVEL

end

-- Clears all objects out of the QuadTree
function QuadTree:clear()

	self.objects:clear()

	-- Recursively clear child nodes
	for i, node in self.child_nodes:members() do
		node:clear()
	end

end


-- Create Children
function QuadTree:subdivide()

	assert(self.level < self.max_level, "Called Subdivide even though this would put us over the max level")

	local child_w = self.aabb.w / QuadTree.CHILD_NODE_SQRT
	local child_h = self.aabb.h / QuadTree.CHILD_NODE_SQRT

	local x = self.aabb.x
	local y = self.aabb.y

	self.child_nodes:insertAt(QuadTree.NW, QuadTree(AABB(x, y, child_w, child_h), self.level + 1, self.max_objects, self.max_level))
	self.child_nodes:insertAt(QuadTree.NE, QuadTree(AABB(x + child_w, y, child_w, child_h), self.level + 1, self.max_objects, self.max_level))
	self.child_nodes:insertAt(QuadTree.SW, QuadTree(AABB(x, y + child_h, child_w, child_h), self.level + 1, self.max_objects, self.max_level))
	self.child_nodes:insertAt(QuadTree.SE, QuadTree(AABB(x+ child_w, y + child_h, child_w, child_h), self.level + 1, self.max_objects, self.max_level))

end	

-- Next, we’ll implement the five methods of a quadtree: clear, split, getIndex, insert, and retrieve.

-- Entity is an object with an aabb member.
function QuadTree:insert(entity)
	
	local aabb = entity.aabb

	-- Ignore items that don't belong in this box
	if not self.aabb:containsAABB(aabb) then
		return false
	end

	-- If I have child nodes, then try to add to a child node


	if self.child_nodes:size() > 0 then

		local quadrant = self:getQuadrant(entity.aabb)

		-- If doesn't fit exactly in any child, add it to self
		if quadrant == QuadTree.PARENT then
			self.objects:add(entity)
			return true
		else
			return self.child_nodes:memberAt(quadrant):insert(entity)
		end
	
	else

		-- If I'm not at my limit, add and return a success
		if self.objects:size() < self.max_objects or self.level >= self.max_level then
			
			self.objects:add(entity)	
			return true
		
		else

			-- If I am, re-partition objects down to children.
			self:subdivide()
			--assert(false, tostring(self.child_nodes))

			-- Re-partition
			for object in self.objects:members() do
				local reassigned = self:insert(object)
				assert(reassigned, tostring(self) .. " We should be able to send this entity to a child: " .. tostring(entity.aabb))
			end

			-- Clear out my object list
			self.objects:clear()

			-- Try to insert base object again
			local added = self:insert(entity)
			assert(added, tostring(self) .. " This should have been sent to one of my children, or back to me. " .. tostring(entity.aabb))

			return added

		end

	end

end	

--[[
 Determine which immediate node the object belongs to. PARENT means
 object cannot completely fit within a child node and is part
 of the parent node
]]

function QuadTree:getQuadrant(aabb)

	local vertical_midpoint = self.aabb.x + self.aabb.half_w
	local horizontal_midpoint = self.aabb.y + self.aabb.half_h

	local fits_in_top_half = aabb.y <= horizontal_midpoint and aabb.y + aabb.h <= horizontal_midpoint
   	local fits_in_bottom_half = aabb.y >= horizontal_midpoint and aabb.y + aabb.h <= self.aabb.y + self.aabb.h

   	local fits_in_left_half = aabb.x <= vertical_midpoint and aabb.x + aabb.w <= vertical_midpoint
   	local fits_in_right_half = aabb.x >= vertical_midpoint and aabb.x + aabb.w <= self.aabb.x + self.aabb.w

   	if fits_in_top_half and fits_in_left_half then
   		return QuadTree.NW
   	elseif fits_in_top_half and fits_in_right_half then
   		return QuadTree.NE
   	elseif fits_in_bottom_half and fits_in_left_half then
   		return QuadTree.SW
   	elseif fits_in_bottom_half and fits_in_right_half then
   		return QuadTree.SE
   	else 
   		return QuadTree.PARENT
   	end

end

function QuadTree:prune()

	local num_contained_objects = self.objects:size()

	local child_nodes_contain_objects = false
	local child_tally = 0

	if self.child_nodes then

		for i, node in self.child_nodes:members() do
			child_tally = child_tally + node:prune()
		end
		
		-- If none of my children have things in them, prune them
		if child_tally == 0 then
			self.child_nodes:clear()
		end

	end

	return num_contained_objects + child_tally
end

function QuadTree:getNodeEntityIsIn(entity)

	-- If I contain it, return me
	if self.objects:contains(entity) then

		return self

	-- Otherwise, try to return which child it is in
	elseif self.child_nodes:size() > 0 then

		local quadrant = self:getQuadrant(entity.aabb)
		assert(quadrant ~= QuadTree.PARENT, "Shouldn't be contained in myself otherwise I should have returned it")

		return self.child_nodes:memberAt(quadrant):getNodeEntityIsIn(entity)

	end

	return nil
end	

function QuadTree:getPossibleOverlaps(object)

	-- Get the lowermost node an entity is in
	local node = self:getNodeEntityIsIn(object)

	assert(node, "Couldn't find a node the entity is in... " .. tostring(object.aabb))

	local set = Set()

	-- Insert all children of that node into possible overlaps
	node:insertPossibleOverlaps(set, object)

	-- Don't intersect with self
	set:remove(object)

	return set

end

function QuadTree:insertPossibleOverlaps(set, object)

	assert(self.aabb:intersects(object.aabb), "Should only be called if we know this qt contains the object")

	set:addSet(self.objects)

	if self.child_nodes:size() > 0 then
		for i, node in self.child_nodes:members() do
			if object.aabb:intersects(node.aabb) then
				node:insertPossibleOverlaps(set, object)
			end
		end
	end

	return set
end

function QuadTree:__tostring()
	return "QuadTree level " .. self.level .. "; aabb: " .. tostring(self.aabb) .. " object #: " .. tostring(self.objects:size())  .. " children #: " .. tostring(self.child_nodes:size())
end