require 'external.middleclass'
require 'math.quad.aabb'
require 'collections.set'
require 'collections.list'
local uuid = require('external.uuid')

--[[

The Quadtree class is straightforward. 
MAX_OBJECTS defines how many objects a node can hold before it splits.
MAX_LEVELS defines the deepest level subnode. 
Level is the current node level (0 being the topmost node)
Bounds represents the 2D space that the node occupies, and nodes are the four subnodes.


]]
QuadTree = class('QuadTree')

local DEFAULT_MAX_OBJECTS = 10
local DEFAULT_MAX_LEVEL = 5

-- Arguments:
-- 		node_sqrt -- how many nodes per side.


--[[


]]

function QuadTree:initialize(node_sqrt, aabb, level, max_objects, max_level)

	assert(node_sqrt, "Must have a node_sqrt")
	assert(aabb, "Must have an aabb")
	assert(level, "Must have a level")
	
	self.uuid = uuid()

	self.aabb = aabb

	self.node_sqrt = node_sqrt

	self.boundary = nil -- AABB of boundary

	self.child_nodes = Set()

	self.objects = Set()

	self.level = level

	-- TODO: hash map

	self.max_objects = max_objects or DEFAULT_MAX_OBJECTS
	self.max_level = max_level or DEFAULT_MAX_LEVEL

end

-- Clears all objects out of the QuadTree
function QuadTree:clear()

	self.objects:clear()

	-- Recursively clear child nodes
	for node in self.child_nodes:members() do
		node:clear()
	end

end


-- Create Children
function QuadTree:subdivide()

	assert(self.level < self.max_level, "Called Subdivide even though this would put us over the max level")

	local child_w = self.aabb.w / self.node_sqrt
	local child_h = self.aabb.h / self.node_sqrt

	local x_limit = self.aabb.x + self.aabb.w - 1
	local y_limit = self.aabb.y + self.aabb.w - 1

	for x = self.aabb.x, x_limit, child_w do
		for y = self.aabb.y, y_limit, child_h do

			local child_aabb = AABB(x, y, child_w, child_h)
			local qt = QuadTree:new(self.node_sqrt, child_aabb, self.level + 1, self.max_objects, self.max_level)
			
			self.child_nodes:add(qt)

		end
	end

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

		local added = false

		-- Try to insert into one of my children. If I do, then just break out
		for node in self.child_nodes:members() do

			added = node:insert(entity)

			if added then
				return true
			end
		end

		-- Otherwise, I have to add it to myself.
		self.objects:add(entity)
		return true
	
	else

		-- Otherwise, check if I'm at my limit. If I'm not, just add to my objects and return true.
		if self.objects:size() < self.max_objects or self.level >= self.max_level then
			
			self.objects:add(entity)
			
			return true
		
		else 

			-- If I am, re-partition objects down to children.
			self:subdivide()

			-- Re-partition
			for object in self.objects:members() do
				local reassigned = self:insert(object)
				assert(reassigned, "We should be able to send this entity to a child: " .. tostring(entity.aabb))
			end

			-- Clear out my object list
			self.objects:clear()

			-- Try to insert base object again
			local added = self:insert(entity)
			assert(added, tostring(self) .. " This should have been sent to one of my children, or back to me. " .. tostring(entity.aabb))

			return true

		end

	end

end	

function QuadTree:getNodeEntityIsIn(entity)

	-- If I contain it, return me
	if self.objects:contains(entity) then

		return self

	-- Otherwise, try to return which child it is in
	elseif self.child_nodes:size() > 0 then

		local contained_node = nil

		for node in self.child_nodes:members() do

			contained_node = node:getNodeEntityIsIn(entity)

			if contained_node then 
				return contained_node
			end

		end

	end

	return nil
end	

function QuadTree:addAllChildObjects(set)

	set:addAll(self.objects)

	for node in self.child_nodes:members() do
		node:addAllChildObjects(set)
	end

	return set

end


function QuadTree:getPossibleOverlaps(object)

	-- Get the lowermost node an entity is in
	local node = self:getNodeEntityIsIn(object)

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

	for node in self.child_nodes:members() do

		if object.aabb:intersects(node.aabb) then
			node:insertPossibleOverlaps(set, object)
		end
	end

	return set
end





function QuadTree:__tostring()
	return "QuadTree level " .. self.level .. "; aabb: " .. tostring(self.aabb) .. " object #: " .. tostring(self.objects:size())  .. " children #: " .. tostring(self.child_nodes:size())
end