require 'external.middleclass'
require 'core.entity.system'



CollisionSystem = class('CollisionSystem', System)

function CollisionSystem:initialize(world)

	System.initialize(self, 'Collision System')

	self.world = world
	self.collisions_to_watch = Set()

end

function CollisionSystem:watchCollision(a, b, callback)

	local config = CollisionConfig(a, b, callback)
	self.collisions_to_watch:add(config)
	return config

end

function CollisionSystem:stopWatchingCollision(config)
	self.collisions_to_watch:remove(config)
end

function CollisionSystem:processCollisions()

	for config in self.collisions_to_watch:members() do
		self:processCollision(config.a, config.b, config.callback)
	end

end

function CollisionSystem:processCollision(a, b, callback)

	-- If A is not active and B is not active


	if instanceOf(Group, a) then
		
		-- Should work whether or not other is a group
		-- TODO inconsistent method of iterating
		for _, member in a:members() do
			processCollision(member, b, callback)
		end
	
	else

		if instanceOf(Group, b) then

			for _, member in b:members() do

				processCollision(a, member, callback)

			end

		else
			-- If collision occurs

			if self:checkCollision(a, b) then

				callback(self, other)
			end
		end

	end

end



function CollisionSystem:checkCollision(entity_a, entity_b)

	if entity_a == entity_b then
		return false
	end

	local em = world:getEntityManager()

	-- Get transform a
	-- Get collider b
	-- Get transform a
	-- Get collider b


	if instanceOf(CircleShape, a) then

		return self:circleCollision(a, b)

	elseif instanceOf(RectangleShape, a) then

		return self:rectangleCollision(a, b)

	elseif instanceOf(PointShape, a) then
		
		return self:pointCollision(b, b)

	end

	assert(false, "My shape is not a legal shape: " .. self)

end


function CollisionSystem:checkCircleCollision(a, b)
	
	-- TODO

	local center = a:center()

	if instanceOf(CircleShape, b) then

		added_radii = a.radius + b.radius


		return Vector.dist(center, b:center()) < added_radii	


	elseif instanceOf(PointShape, b) then

		return b:collidesWith(a)

	elseif instanceOf(RectangleShape, b) then

		-- From: http://stackoverflow.com/a/1879223

		-- Find closest point
		local closestX = clamp(center.x, b.position.x, b.position.x + b.width)
		local closestY = clamp(center.y, b.position.y, b.position.y + b.height)

		local closest_point = Vector(closestX, closestY)

		-- Check to see if this point is within circle
		return Vector.dist(center, closest_point) < a.radius

	end

end


function Collidable.pointCollision(self, other)


	if instanceOf(CircleShape, other) then

		-- Distance from point to center of circle < radius
		return Vector.dist(self.position, other:center()) < other.radius

	elseif instanceOf(PointShape, other) then

		-- Same point

		return self.position == other.position

	elseif instanceOf(RectangleShape, other) then

		-- Lies within bounds

		return self.position.x > other.position.x and
				self.position.x < other.position.x + other.width and
				self.position.y > other.position.y and
				self.position.y < other.position.y + other.height

	end

end


function Collidable.rectangleCollision(self, other)
	

	if instanceOf(CircleShape, other) then

		return other:collidesWith(self)

	elseif instanceOf(PointShape, other) then

		return other:collidesWith(self)

	elseif instanceOf(RectangleShape, other) then

		-- If any of these are true, then they don't intersect, so return "not" of that.
		-- 0, 0 is in upper left hand corner.
		return not (
			 		-- the X coord of my upper right is less than x coord of other upper left
					self.position.x + self.width < other.position.x or
					-- the X coord of other's upper right is less than x coord of my upper left
					other.position.x + other.width < self.position.x or

					-- the Y coord of my upper right is less than Y coord of other upper left
					self.position.y + self.height < other.position.y or 

					-- the Y coord of other's upper right is less than than Y coord of my upper left
					other.position.y + other.height < self.position.y
				)
	end

end



--[[ Helper Structs ]]
CollisionConfig = class('CollisionConfig')

function CollisionConfig:initialize(a, b, callback)
	self.a = a
	self.b = b
	self.callback = callback
end


CollisionEvent = class('CollisionEvent')

function CollisionEvent:initialize(a, b)
	self.a = a
	self.b = b
end
