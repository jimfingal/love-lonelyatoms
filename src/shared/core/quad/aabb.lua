require 'external.middleclass'

AABB = class('AABB')

function AABB:initialize(x, y, w, h)
	self.x = x
	self.y = y
	self.w = w
	self.h = h
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