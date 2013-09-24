require 'external.middleclass'
require 'core.entity.component'
require 'core.vector'

Motion = class('Motion', Component)

function Motion:initialize()

	Component.initialize(self, 'Motion')

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

function Motion:getVelocity()
	return self.velocity:clone()
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


function Motion:getAcceleration()
	return self.acceleration
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

function Motion:setDrag(x, y)
	self.drag.x = x
	self.drag.y = y
	return self
end


function Motion:capVelocity()
    if self.velocity > self.maxVelocity then
        self.velocity = self.maxVelocity
    elseif self.velocity < self.minVelocity then
        self.velocity = self.minVelocity
    end
   	return self
end

function Motion:stop()
	self.velocity = Vector.ZERO:clone()
	self.acceleration = Vector.ZERO:clone()
	return self
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



