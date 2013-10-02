require 'external.middleclass'
require 'core.quad.aabb'
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

	self.child_nodes = List()

	self.objects = Set()

	self.level = level

	self.max_objects = max_objects or DEFAULT_MAX_OBJECTS
	self.max_level = max_level or DEFAULT_MAX_LEVEL

end

-- Clears all objects out of the QuadTree
function QuadTree:clear()

	self.objects:clear()

	-- Recursively clear child nodes
	for node in child_nodes:members() do
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
			
			self.child_nodes:append(qt)

		end
	end

end	

-- Next, we’ll implement the five methods of a quadtree: clear, split, getIndex, insert, and retrieve.


function QuadTree:insert(entity)
	self.entities:add(entity)
end	


function QuadTree:queryRange(aabb)
	-- TODO
end	

function QuadTree:__tostring()
	return "QuadTree " .. self.level .. ": " .. self.uuid .. " : " .. tostring(self.aabb)
end