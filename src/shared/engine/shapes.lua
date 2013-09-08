require 'engine.vector'
require 'external.middleclass'

Shape = class('Shape')

function Shape:initialize()

end

-- Circles

CircleShape = class('CircleShape', Shape)

function CircleShape:initialize(x, y, radius)

	self.center = Vector(x, y)
	self.radius = radius

end

function CircleShape:collidesWith(other)
	
	-- assert(instanceOf(Shape, other), "Can only collide with other shapes")

	if self == other then 
		return false 
	end

	if instanceOf(CircleShape, other) then

		added_radii = self.radius + other.radius

		return Vector.dist(self.center, other.center) < added_radii	


	elseif instanceOf(PointShape, other) then

		return other:collidesWith(self)

	elseif instanceOf(RectangleShape, other) then

		-- From: http://stackoverflow.com/a/1879223

		-- Find closest point
		local closestX = clamp(self.center.x, other.upper_left.x, other.upper_left.x + other.width)
		local closestY = clamp(self.center.y, other.upper_left.y, other.upper_left.y + other.height)

		local closest_point = Vector(closestX, closestY)

		-- Check to see if this point is within circle
		return Vector.dist(self.center, closest_point) < self.radius

	end

end

function clamp(value, min, max)
	return math.max(min, math.min(max, value))
end

function CircleShape:moveTo(x, y)
	self.center = Vector(x, y)
end

function CircleShape:draw(mode)
	love.graphics.circle(mode or 'line', self.center.x, self.center.y, self.radius)
end


-- Points

PointShape = class('PointShape', Shape)

function PointShape:initialize(x, y)

	self.center = Vector(x, y)

end

function PointShape:collidesWith(other)
	
	-- assert(instanceOf(Shape, other), "Can only collide with other shapes")

	if self == other then 
		return false 
	end

	if instanceOf(CircleShape, other) then

		-- Distance from point to center of circle < radius
		
		return Vector.dist(self.center, other.center) < other.radius

	elseif instanceOf(PointShape, other) then

		-- Same point

		return self.center == other.center

	elseif instanceOf(RectangleShape, other) then

		-- Lies within bounds

		return self.center.x > other.upper_left.x and
				self.center.x < other.upper_left.x + other.width and
				self.center.y > other.upper_left.y and
				self.center.y < other.upper_left.y + other.height

	end

end

function PointShape:moveTo(x, y)
	self.center = Vector(x, y)
end

function PointShape:draw()
	love.graphics.point(self.center.x, self.center.y)
end

-- Rectangles

RectangleShape = class('RectangleShape', Shape)

-- X and Y are point in upper left hand corner
function RectangleShape:initialize(x, y, width, height)

	self.upper_left = Vector(x, y)
	self.width = width
	self.height = height

end

function RectangleShape:collidesWith(other)
	
	-- assert(instanceOf(Shape, other), "Can only collide with other shapes")

	if self == other then 
		return false 
	end

	if instanceOf(CircleShape, other) then

		return other:collidesWith(self)

	elseif instanceOf(PointShape, other) then

		return other:collidesWith(self)

	elseif instanceOf(RectangleShape, other) then

		-- If any of these are true, then they don't intersect, so return "not" of that.
		-- 0, 0 is in upper left hand corner.
		return not (
			 		-- the X coord of my upper right is less than x coord of other upper left
					self.upper_left.x + self.width < other.upper_left.x or
					-- the X coord of other's upper right is less than x coord of my upper left
					other.upper_left.x + other.width < self.upper_left.x or

					-- the Y coord of my upper right is less than Y coord of other upper left
					self.upper_left.y + self.height < other.upper_left.y or 

					-- the Y coord of other's upper right is less than than Y coord of my upper left
					other.upper_left.y + other.height < self.upper_left.y
				)
	end

end

function RectangleShape:moveTo(x, y)
	self.upper_left = Vector(x, y)
end

function RectangleShape:draw(mode)
	love.graphics.rectangle(mode or "line", self.upper_left.x, self.upper_left.y, self.width, self.height)
end


-- TODO: make these all use transforms