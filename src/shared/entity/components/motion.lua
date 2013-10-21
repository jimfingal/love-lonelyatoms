require 'external.middleclass'
require 'entity.component'
require 'math.vector2'

Motion = class('Motion', Component)

function Motion:initialize()

	Component.initialize(self, 'Motion')

	-- Property: velocity
	-- Motion either along the x or y axes, in pixels per second.
	self.velocity = Vector2(0, 0)

	-- Property: minSpeed
	-- No matter what else may affect this sprite's velocity, it's length
	-- will never go below this number.
	self.minSpeed = 0

	-- Property: maxSpeed
	-- No matter what else may affect this sprite's velocity, it's length will
	-- never go above this number.
	self.maxSpeed = math.huge


	-- Property: minVelocity
	-- No matter what else may affect this sprite's velocity, it's x and y values
	-- will never go below these numbers.
	self.minVelocity = Vector2(-math.huge, -math.huge)

	-- Property: maxVelocity
	-- No matter what else may affect this sprite's velocity, it's x and y values
	-- never go above these numbers.
	self.maxVelocity =  Vector2(math.huge, math.huge)


	-- Property: acceleration
	-- Acceleration along the x or y axes, or rotation about its center, in
	-- pixels per second squared.
	self.acceleration = Vector2(0, 0)

	-- Property: minAcceleration
	-- No matter what else may affect this sprite's velocity, it
	-- will never go below these numbers.
	self.minAcceleration = Vector2(0, 0)

	-- Property: max acceleration
	-- No matter what else may affect this sprite's acceleration, it will
	-- never go above these numbers.
	self.maxAcceleration = Vector2(math.huge, math.huge)

	-- Property: drag
	self.drag = Vector2(0, 0)

	self.active = true

end

function Motion:getVelocity()
	return self.velocity
end

function Motion:setVelocity(x, y)
	self.velocity.x = x
	self.velocity.y = y
	return self
end


function Motion:invertVerticalVelocity()
	self.velocity.y = -self.velocity.y
	return self
end

function Motion:invertHorizontalVelocity()
	self.velocity.x = -self.velocity.x
	return self
end


function Motion:setMinVelocity(x, y)
	self.minVelocity.x = x
	self.minVelocity.y = y
	return self
end

function Motion:setMaxVelocity(x, y)
	self.maxVelocity.x = x
	self.maxVelocity.y = y
	return self
end

function Motion:setMinSpeed(min)
	self.minSpeed = min
	return self
end

function Motion:setMaxSpeed(max)
	self.maxSpeed = max
	return self
end


function Motion:getAcceleration()
	return self.acceleration
end

function Motion:accelerate(dx, dy)
	self.acceleration.x = self.acceleration.x + dx
	self.acceleration.y = self.acceleration.y + dy
	return self
end


function Motion:setAcceleration(x, y)
	self.acceleration.x = x
	self.acceleration.y = y
	return self
end


function Motion:setMinAcceleration(x, y)
	self.minAcceleration.x = x
	self.minAcceleration.y = y
	return self
end

function Motion:setMaxAcceleration(x, y)
	self.maxAcceleration.x = x
	self.maxAcceleration.y = y
	return self
end

function Motion:capAcceleration()

	if self.acceleration > self.maxAcceleration then

		self.acceleration:normalize_inplace()
		self.acceleration:multiply(self.maxAcceleration:len())

	elseif self.acceleration < self.minAcceleration then
    
        self.acceleration:normalize_inplace()
		self.acceleration:multiply(self.minAcceleration:len())
    
    end


	return self
end

function Motion:setDrag(x, y)
	self.drag.x = x
	self.drag.y = y
	return self
end


function Motion:capVelocity()

	if self.velocity.x > self.maxVelocity.x then
		
		self.velocity.x = self.maxVelocity.x

	elseif self.velocity.x < self.minVelocity.x then

		self.velocity.x = self.minVelocity.x

	end


	if self.velocity.y > self.maxVelocity.y then
		
		self.velocity.y = self.maxVelocity.y

	elseif self.velocity.y < self.minVelocity.y then

		self.velocity.y = self.minVelocity.y

	end

	if self.velocity:len() > self.maxSpeed then

		self.velocity:normalize_inplace()
		self.velocity:multiply(self.maxSpeed)

	elseif self.velocity:len() < self.minSpeed then
    
        self.velocity:normalize_inplace()
		self.velocity:multiply(self.minSpeed)
    
    end

	
   	return self
end

function Motion:stop()
	self.velocity.x = 0
	self.velocity.y = 0
	self.acceleration.x = 0
	self.acceleration.y = 0
	return self
end

function Motion:isActive()
	return self.active
end	

function Motion:activate()
	self.active = true
	return self
end	

function Motion:deactivate()
	self.active = false
end	


function Motion:__tostring()
	return "Motion: [ velocity = " .. tostring(self.velocity) .. 
					   ", minVelocity = " .. tostring(self.minVelocity) .. 
					   ", maxVelocity = " .. tostring(self.maxVelocity) .. 
					   ", acceleration = " .. tostring(self.acceleration) .. 
					   ", minAcceleration = " .. tostring(self.minAcceleration) .. 
					   ", maxAcceleration = " .. tostring(self.maxAcceleration) .. 
					   ", drag = " .. tostring(self.drag) .."]" 

end



return Motion
