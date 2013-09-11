require 'external.middleclass'
require 'helpers.mathhelpers'

Collidable = {}

function Collidable.collidableInit(self, hitbox)

	self.hitbox = hitbox
	self.solid = true

end


function Collidable.collidesWith(self, other)

	--[[
	if not includes(Collidable, other) then
		assert(false, "Not colliding with a legal shape")
	end
	]]

	if self == other then
		return false
	end

	if instanceOf(CircleShape, self.hitbox) then

		return self:circleCollision(other)

	elseif instanceOf(RectangleShape, self.hitbox) then

		return self:rectangleCollision(other)

	elseif instanceOf(PointShape, self.hitbox) then
		
		return self:pointCollision(other)

	end

	assert(false, "My shape is not a legal shape: " .. self.hitbox)

end


function Collidable.circleCollision(self, other)
	
	-- assert(instanceOf(Shape, other), "Can only collide with other shapes")

	if self == other then 
		return false 
	end

	local center = self.hitbox:center(self.position)

	if instanceOf(CircleShape, other.hitbox) then

		added_radii = self.hitbox.radius + other.hitbox.radius

		local other_center = other.hitbox:center(other.position)

		return Vector.dist(center, other_center) < added_radii	


	elseif instanceOf(PointShape, other.hitbox) then

		return other:collidesWith(self)

	elseif instanceOf(RectangleShape, other.hitbox) then

		-- From: http://stackoverflow.com/a/1879223

		-- Find closest point
		local closestX = clamp(center.x, other.position.x, other.position.x + other.hitbox.width)
		local closestY = clamp(center.y, other.position.y, other.position.y + other.hitbox.height)

		local closest_point = Vector(closestX, closestY)

		-- Check to see if this point is within circle
		return Vector.dist(center, closest_point) < self.hitbox.radius

	end

end


function Collidable.pointCollision(self, other)


	if instanceOf(CircleShape, other.hitbox) then

		-- Distance from point to center of circle < radius
		return Vector.dist(self.position, other.hitbox:center(other.position)) < other.hitbox.radius

	elseif instanceOf(PointShape, other.hitbox) then

		-- Same point

		return self.position == other.position

	elseif instanceOf(RectangleShape, other.hitbox) then

		-- Lies within bounds

		return self.position.x > other.position.x and
				self.position.x < other.position.x + other.hitbox.width and
				self.position.y > other.position.y and
				self.position.y < other.position.y + other.hitbox.height

	end

end


function Collidable.rectangleCollision(self, other)
	

	if instanceOf(CircleShape, other.hitbox) then

		return other:collidesWith(self)

	elseif instanceOf(PointShape, other.hitbox) then

		return other:collidesWith(self)

	elseif instanceOf(RectangleShape, other.hitbox) then

		-- If any of these are true, then they don't intersect, so return "not" of that.
		-- 0, 0 is in upper left hand corner.
		return not (
			 		-- the X coord of my upper right is less than x coord of other upper left
					self.position.x + self.hitbox.width < other.position.x or
					-- the X coord of other's upper right is less than x coord of my upper left
					other.position.x + other.hitbox.width < self.position.x or

					-- the Y coord of my upper right is less than Y coord of other upper left
					self.position.y + self.hitbox.height < other.position.y or 

					-- the Y coord of other's upper right is less than than Y coord of my upper left
					other.position.y + other.hitbox.height < self.position.y
				)
	end

end

function Collidable.processCollision(self, other, callback)

	if instanceOf(Group, self) then
		
		-- Should work whether or not other is a group
		for _, member in self:members() do
			member:processCollision(other, callback)
		end
	
	else

		if instanceOf(Group, other) then

			for _, member in other:members() do

				self:processCollision(member, callback)

			end

		else
			-- If collision occurs

			if includes(Collidable, other.class) and other.active and self:collidesWith(other) then

				callback(self, other)
			end
		end

	end

end


