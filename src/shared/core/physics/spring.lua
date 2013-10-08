require 'external.middleclass'

Spring = class("Spring")

function Spring:initialize(x, target_height)

	self.k = 0.025
	self.target_height = target_height
	self.position = Vector(x, target_height)
	self.y_velocity = 0
	self.dampening = 0

end



function Spring:update(dt)
	
	local x = self.position.y - self.target_height
	local y_acceleration =  -k * x - self.dampening

	self.position.y = self.position.y + self.y_velocity * dt
 	self.y_velocity = self.y_velocity + y_acceleration * dt

end