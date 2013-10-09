require 'external.middleclass'
require 'entity.system'
require 'entity.components.transform'
require 'entity.components.collider'
require 'math.util'


CollisionSystem = class('CollisionSystem', System)

function CollisionSystem:initialize(world)

	System.initialize(self, 'Collision System')

	self.world = world
	self.collisions_to_watch = Set()
	self._frame_collisions = Set()
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

	self._frame_collisions:clear()

	for config in self.collisions_to_watch:members() do
	
		local a = config.a
		local b = config.b

		-- First has many, second has one
		if instanceOf(Set, a) then

			if instanceOf(Set, b) then
				self:checkGroupToGroup(a, b, self._frame_collisions)
			else 
				self:checkGroupToOne(a, b, self._frame_collisions)
			end
			
		elseif instanceOf(Set, b) then

			-- TODO: feels hacky that the order matters in our handling
			for member in b:members() do
				self:addCollisionToFrameIfExists(a, member, self._frame_collisions)
			end

		else
			self:addCollisionToFrameIfExists(a, b, self._frame_collisions)
		end

	end


	return self._frame_collisions

end

function CollisionSystem:checkGroupToGroup(group1, group2, set)
	for member1 in group1:members() do
		for member2 in group2:members() do
			self:addCollisionToFrameIfExists(member1, member2, set)
		end
	end
end

function CollisionSystem:checkGroupToOne(group, single, set)
	for member in group:members() do
		self:addCollisionToFrameIfExists(member, single, set)
	end
end

function CollisionSystem:addCollisionToFrameIfExists(a, b, set)

	local collision_event = self:checkCollision(a, b)

	if collision_event then
		set:add(collision_event)
	end
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

local _point = Vector2(0, 0)

function CollisionSystem:circleCollision(at, ac, bt, bc)
	
	local a_circle = ac:hitbox()

	local a_center = a_circle:center(at:getPosition())

	if instanceOf(CircleShape, bc:hitbox()) then

		local b_circle = bc:hitbox()
		local b_center = b_circle:center(bt:getPosition())

		local added_radii = a_circle.radius + b_circle.radius

		return Vector2.dist(a_center, b_center) < added_radii	


	elseif instanceOf(PointShape, bc:hitbox()) then

		return self:pointCollision(bt, bc, at, ac)

	elseif instanceOf(RectangleShape, bc:hitbox()) then

		-- From: http://stackoverflow.com/a/1879223

		local b_rectangle = bc:hitbox()
		local b_upper_left_x = bt:getPosition().x + b_rectangle:offset().x
		local b_upper_left_y = bt:getPosition().y + b_rectangle:offset().y

		-- Find closest point
		local closestX = clamp(a_center.x, b_upper_left_x, b_upper_left_x + b_rectangle.width)
		local closestY = clamp(a_center.y, b_upper_left_y, b_upper_left_y + b_rectangle.height)

		_point.x = closestX
		_point.y = closestY

		-- Check to see if this point is within circle
		return Vector2.dist(a_center, _point) < a_circle.radius

	end

end


function CollisionSystem:pointCollision(at, ac, bt, bc)


	local a_point = at:getPosition() + ac:hitbox():offset()

	if instanceOf(CircleShape, bc:hitbox()) then

		local b_circle = bc:hitbox()
		local b_center = b_circle:center(bt:getPosition())

		-- Distance from point to center of circle < radius
		return Vector2.dist(a_point, b_center) < b_circle.radius

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
		local a_upper_left_x = at:getPosition().x + a_rectangle:offset().x
		local a_upper_left_y = at:getPosition().y + a_rectangle:offset().y

		local b_rectangle = bc:hitbox()
		local b_upper_left_x = bt:getPosition().x + b_rectangle:offset().x
		local b_upper_left_y = bt:getPosition().y + b_rectangle:offset().y


		-- If any of these are true, then they don't intersect, so return "not" of that.
		-- 0, 0 is in upper left hand corner.
		return not (
			 		-- the X coord of my upper right is less than x coord of other upper left
					a_upper_left_x + a_rectangle.width < b_upper_left_x or
					-- the X coord of other's upper right is less than x coord of my upper left
					b_upper_left_x + b_rectangle.width < a_upper_left_x or

					-- the Y coord of my lower right is less than Y coord of other upper left
					a_upper_left_y + a_rectangle.height < b_upper_left_y  or 

					-- the Y coord of other's lower right is less than than Y coord of my upper left
					b_upper_left_y  + b_rectangle.height < a_upper_left_y
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
