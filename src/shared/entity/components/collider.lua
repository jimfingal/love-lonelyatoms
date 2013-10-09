require 'external.middleclass'
require 'entity.component'

Collider = class('Collider', Component)

function Collider:initialize()

	Component.initialize(self, 'Collider')

	self.shape_data = nil
	self.active = true

end

function Collider:setHitbox(shape_data)
	self.shape_data = shape_data
	return self
end

function Collider:hitbox()
	return self.shape_data
end


function Collider:isActive()
	return self.active
end

function Collider:enable()
	self.active = true
	return self
end

function Collider:disable()
	self.active = false
	return self
end


function Collider:__tostring()
	return "Collider: [ active = " .. tostring(self.active) .. ", shape = " .. tostring(self.shape_data) .. "]" 
end
