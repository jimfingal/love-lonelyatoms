require 'external.middleclass'

-- Axis-aligned bounding box
AABB = class('AABB')

function AABB:initialize(x, y, w, h)

	assert(x, "Must have an x param")
	assert(y, "Must have an y param")
	assert(w, "Must have an w param")
	assert(h, "Must have an h param")

	self.x = x
	self.y = y
	self.w = w
	self.h = h

	self.half_w = w / 2
	self.half_h = h / 2
end

-- TOOD: test
function AABB:containsAABB(aabb)

	return
			-- Other x value is greater or equal to my x value
			aabb.x >= self.x and
			-- Other's right hand x calue is less than or equal to my right hand value
			aabb.x + aabb.w <= self.x + self.w and
			-- Other's top y greater or equal to my top y value
			aabb.y >= self.y and
			-- Other's bottom y is less than or equal to my bottom y
			aabb.y + aabb.h <= self.y + self.h 
end


function AABB:containsPoint(px, py)

	return px > self.x and
			px < self.x + self.w and
			py > self.y and
			py < self.y + self.h

end


function AABB:intersects(other)

	-- If any of these are true, then they don't intersect, so return "not" of that.
	-- 0, 0 is in upper left hand corner.
	return not (
		 		-- the X coord of my upper right is less than x coord of other upper left
				self.x + self.w < other.x or
				-- the X coord of other's upper right is less than x coord of my upper left
				other.x + other.w < self.x or

				-- the Y coord of my lower right is less than Y coord of other upper left
				self.y + self.h < other.y  or 

				-- the Y coord of other's lower right is less than than Y coord of my upper left
				other.y  + other.h < self.y
			)

end


function AABB:__tostring()
	return "AABB: [x=" .. tostring(self.x) .. ", y=" .. tostring(self.y) ..", w=" .. tostring(self.w) .. ", h=" .. tostring(self.h) .. "]"
end