require 'external.middleclass'
require 'core.entity.system'
require 'core.components.transform'
require 'core.components.collider'
require 'utils.mathutils'


CollisionSystem = class('CollisionSystem', System)

function CollisionSystem:initialize(world)

	System.initialize(self, 'Collision System')

	self.world = world
	self.collisions_to_watch = Set()

end


function CollisionSystem:reset()
	self.collisions_to_watch = Set()
end


function CollisionSystem:watchCollision(a, b)

	local config = CollisionConfig(a, b)
	self.collisions_to_watch:add(config)
	return config

end

function CollisionSystem:stopWatchingCollision(config)
	self.collisions_to_watch:remove(config)
end

-- TODO: take entity set input
function CollisionSystem:getCollisions()

	local collisions = Set()

	for config in self.collisions_to_watch:members() do
	
		-- Could be empty
		local collision_events = self:getCollisionEvents(config.a, config.b)		
		collisions:addSet(collision_events)

	end

	return collisions

end

-- 
function CollisionSystem:getCollisionEvents(a, b)

	-- If A is not active and B is not active

	local collision_events = Set()

	if instanceOf(Set, a) then
		
		-- Should work whether or not other is a group
		-- TODO inconsistent method of iterating
		for member in a:members() do

			local child_collisions = self:getCollisionEvents(member, b)
			collision_events:addSet(child_collisions)
	 
		end
	
	else

		if instanceOf(Set, b) then

			for member in b:members() do

				local child_collisions = self:getCollisionEvents(a, member)
				collision_events:addSet(child_collisions)

			end

		else
			-- If collision occurs

			local collision_event = self:checkCollision(a, b)

			if collision_event then
				collision_events:add(collision_event)
			end
		end

	end

	return collision_events

end



function CollisionSystem:checkCollision(entity_a, entity_b)

	assert(entity_a, "Must have an 'A' entity")
	assert(entity_b, "Must have a 'B' entity... " .. tostring(entity_a))

	if entity_a == entity_b then
		return nil
	end

	local em = self.world:getEntityManager()

	-- Transform and Collider
	at = entity_a:getComponent(Transform)
    ac = entity_a:getComponent(Collider)

    -- Transform and coollider
	bt = entity_b:getComponent(Transform)
    bc = entity_b:getComponent(Collider)

    if not ac:isActive() or not bc:isActive() then
    	return nil
    end

    -- TODO: Shape Helpers that resolve offset

	if instanceOf(CircleShape, ac:hitbox()) then

		if self:circleCollision(at, ac, bt, bc) then
			return CollisionEvent(entity_a, entity_b)
		else
			return nil
		end

	elseif instanceOf(RectangleShape, ac:hitbox()) then

		if self:rectangleCollision(at, ac, bt, bc) then
			return CollisionEvent(entity_a, entity_b)
		else
			return nil
		end

	elseif instanceOf(PointShape, ac:hitbox()) then
		
		if self:pointCollision(at, ac, bt, bc) then 
			return CollisionEvent(entity_a, entity_b)
		else
			return nil
		end
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

function CollisionConfig:initialize(a, b)
	self.a = a
	self.b = b
end

CollisionEvent = class('CollisionEvent')

function CollisionEvent:initialize(a, b)
	self.a = a
	self.b = b
end
