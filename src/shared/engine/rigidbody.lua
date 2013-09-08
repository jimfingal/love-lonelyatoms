require 'external.middleclass'
require 'engine.vector'

RigidBody = class('RigidBody')

function RigidBody:initialize()

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

function RigidBody:setVelocity(x, y)
	self.velocity.x = x
	self.velocity.y = y
end

function RigidBody:setMinVelocity(x, y)
	self.minVelocity.x = x
	self.minVelocity.y = y
end

function RigidBody:setMaxVelocity(x, y)
	self.maxVelocity.x = x
	self.maxVelocity.y = y
end

function RigidBody:setAcceleration(x, y)
	self.acceleration.x = x
	self.acceleration.y = y
end


function RigidBody:setMinAcceleration(x, y)
	self.minAcceleration.x = x
	self.minAcceleration.y = y
end

function RigidBody:setMaxAcceleration(x, y)
	self.maxAcceleration.x = x
	self.maxAcceleration.y = y
end

function RigidBody:setDrag(x, y)
	self.drag.x = x
	self.drag.y = y
end


function RigidBody:__tostring()
	return "( velocity: " .. tostring(self.velocity) .. 
		", min velocity: " .. tostring(self.minVelocity) .. 
		", max velocity: " .. tostring(self.maxVelocity) .. 
		", acceleration: " .. tostring(self.acceleration) .. 
		", min acceleration: " .. tostring(self.minAcceleration) .. 
		", max acceleration: " .. tostring(self.maxAcceleration) ..
		", drag: " .. tostring(self.drag) 

	
end
