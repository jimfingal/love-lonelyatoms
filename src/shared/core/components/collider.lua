require 'external.middleclass'

Collider = class('Collider', Component)

function Collider:initialize()

	Component.initialize(self, 'Collider')

	self.shape_data = nil
	self.active = true

end

function Collider:setShape(shape_data)
	self.shape_data = shape_data
	return self
end

function Collider:getShape()
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
