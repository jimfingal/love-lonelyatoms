require 'external.middleclass'
require 'core.entity.system'
require 'core.components.transform'
require 'core.components.collider'
require 'helpers.mathhelpers'



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


	if instanceOf(Set, a) then
		
		-- Should work whether or not other is a group
		-- TODO inconsistent method of iterating
		for _, member in a:members() do
			processCollision(member, b, callback)
		end
	
	else

		if instanceOf(Set, b) then

			for _, member in b:members() do

				processCollision(a, member, callback)

			end

		else
			-- If collision occurs

			if self:checkCollision(a, b) then

				callback(a, b)
			end
		end

	end

end



function CollisionSystem:checkCollision(entity_a, entity_b)

	if entity_a == entity_b then
		return false
	end

	local em = world:getEntityManager()

	-- Transform and Collider
	at = em:getComponent(entity_a, Transform)
    ac = em:getComponent(entity_a, Collider)

    -- Transform and coollider
	bt = em:getComponent(entity_b, Transform)
    bc = em:getComponent(entity_b, Collider)

    if not ac:isActive() or not bc:isActive() then
    	return false
    end


	if instanceOf(CircleShape, ac:hitbox()) then

		return self:circleCollision(at, ac, bt, bc)

	elseif instanceOf(RectangleShape, ac:hitbox()) then

		return self:rectangleCollision(at, ac, bt, bc)

	elseif instanceOf(PointShape, ac:hitbox()) then
		
		return self:pointCollision(at, ac, bt, bc)

	end

	assert(false, "My shape is not a legal shape: " .. self)

end


function CollisionSystem:circleCollision(at, ac, bt, bc)
	
	local a_circle = ac:hitbox()

	local a_center = a_circle:center(at:getPosition())

	if instanceOf(CircleShape, bc:hitbox()) then

		local b_circle = bc:hitbox()
		local b_center = b_circle:center(bt:getPosition())

		local added_radii = a_circle.radius + b_circle.radius

		return Vector.dist(a_center, b_center) < added_radii	


	elseif instanceOf(PointShape, bc:hitbox()) then

		return self:pointCollision(bt, bc, at, ac)

	elseif instanceOf(RectangleShape, bc:hitbox()) then

		-- From: http://stackoverflow.com/a/1879223

		local b_rectangle = bc:hitbox()
		local b_upper_left = bt:getPosition() + b_rectangle:offset()

		-- Find closest point
		local closestX = clamp(a_center.x, b_upper_left.x, b_upper_left.x + b_rectangle.width)
		local closestY = clamp(a_center.y, b_upper_left.y, b_upper_left.y + b_rectangle.height)

		local closest_point = Vector(closestX, closestY)

		-- Check to see if this point is within circle
		return Vector.dist(a_center, closest_point) < a_circle.radius

	end

end


function CollisionSystem:pointCollision(at, ac, bt, bc)


	local a_point = at:getPosition() + ac:hitbox():offset()

	if instanceOf(CircleShape, bc:hitbox()) then

		local b_circle = bc:hitbox()
		local b_center = b_circle:center(bt:getPosition())

		-- Distance from point to center of circle < radius
		return Vector.dist(a_point, b_center) < b_circle.radius

	elseif instanceOf(PointShape, bc:hitbox()) then

		-- Same point
		local b_point = bt:getPosition() + bc:hitbox():offset()

		return a_point == b_point

	elseif instanceOf(RectangleShape, bc:hitbox()) then


		local b_rectangle = bc:hitbox()
		local b_upper_left = bt:getPosition() + b_rectangle:offset()

		-- Lies within bounds

		return a_point.x > b_upper_left.x and
				a_point.x < b_upper_left.x + b_rectangle.width and
				a_point.y > b_upper_left.y and
				a_point.y < b_upper_left.y + b_rectangle.height

	end

end


function CollisionSystem:rectangleCollision(at, ac, bt, bc)
	

	if instanceOf(CircleShape, bc:hitbox()) then

		return self:circleCollision(bt, bc, at, ac)

	elseif instanceOf(PointShape, bc:hitbox()) then

		return self:pointCollision(bt, bc, at, ac)

	elseif instanceOf(RectangleShape, bc:hitbox()) then


		local a_rectangle = ac:hitbox()
		local a_upper_left = at:getPosition() + a_rectangle:offset()

		local b_rectangle = bc:hitbox()
		local b_upper_left = bt:getPosition() + b_rectangle:offset()



		-- If any of these are true, then they don't intersect, so return "not" of that.
		-- 0, 0 is in upper left hand corner.
		return not (
			 		-- the X coord of my upper right is less than x coord of other upper left
					a_upper_left.x + a_rectangle.width < b_upper_left.x or
					-- the X coord of other's upper right is less than x coord of my upper left
					b_upper_left.x + b_rectangle.width < a_upper_left.x or

					-- the Y coord of my upper right is less than Y coord of other upper left
					a_upper_left.y + a_rectangle.height < b_upper_left.y or 

					-- the Y coord of other's upper right is less than than Y coord of my upper left
					b_upper_left.y + b_rectangle.height < a_upper_left.y
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
