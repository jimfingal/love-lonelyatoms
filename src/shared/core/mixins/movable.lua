require 'core.vector'

Movable = {}

function Movable.movableInit(self)

	-- Property: rotation
	-- Rotation of drawn sprite in radians.
	self.rotation = 0

	-- Property: velocity
	-- Motion either along the x or y axes, in pixels per second.
	self.velocity = Vector(0, 0)

	-- Property: minVelocity
	-- No matter what else may affect this sprite's velocity, it
	-- will never go below these numbers.
	self.minVelocity = Vector(- math.huge, - math.huge)

	-- Property: maxVelocity
	-- No matter what else may affect this sprite's velocity, it will
	-- never go above these numbers.
	self.maxVelocity = Vector(math.huge, math.huge)

	-- Property: acceleration
	-- Acceleration along the x or y axes, or rotation about its center, in
	-- pixels per second squared.
	self.acceleration = Vector(0, 0)

	-- Property: minAcceleration
	-- No matter what else may affect this sprite's velocity, it
	-- will never go below these numbers.
	self.minAcceleration = Vector(- math.huge, - math.huge)

	-- Property: max acceleration
	-- No matter what else may affect this sprite's acceleration, it will
	-- never go above these numbers.
	self.maxAcceleration = Vector(math.huge, math.huge)

	-- Property: drag
	self.drag = Vector(0, 0)

end

function Movable.position(self)
	return self.position
end

function Movable.moveTo(self, x, y)
	self.position.x = x;
	self.position.y = y;
end

function Movable.move(self, dx, dy)
	self.position.x = self.position.x + dx;
	self.position.y = self.position.y + dy;
end


function Movable.setVelocity(self, x, y)
	self.velocity.x = x
	self.velocity.y = y
end

function Movable.setMinVelocity(self, x, y)
	self.minVelocity.x = x
	self.minVelocity.y = y
end

function Movable.setMaxVelocity(self, x, y)
	self.maxVelocity.x = x
	self.maxVelocity.y = y
end

function Movable.setAcceleration(self, x, y)
	self.acceleration.x = x
	self.acceleration.y = y
end


function Movable.setMinAcceleration(self, x, y)
	self.minAcceleration.x = x
	self.minAcceleration.y = y
end

function Movable.setMaxAcceleration(self, x, y)
	self.maxAcceleration.x = x
	self.maxAcceleration.y = y
end

function Movable.setDrag(self, x, y)
	self.drag.x = x
	self.drag.y = y
end


function Movable.capVelocity(self)
    if self.velocity > self.maxVelocity then
        self.velocity = self.maxVelocity
    elseif self.velocity < self.minVelocity then
        self.velocity = self.minVelocity
    end
end
