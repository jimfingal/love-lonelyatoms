require 'external.middleclass'
require 'core.entity.component'
require 'core.vector'


Transform = class('Transform', Component)

function Transform:initialize(x, y)

	Component.initialize(self, 'Transform')

	self.position = Vector(x or 0, y or 0)
	self.rotation = 0 -- Rotation in Radians
	self.scale = Vector(1, 1)

end

--[[ Position ]]

function Transform:moveTo(x, y)
	self.position.x = x;
	self.position.y = y;
	return self
end

function Transform:move(dx, dy)
	self.position.x = self.position.x + dx;
	self.position.y = self.position.y + dy;
	return self
end

function Transform:getPosition()
	return self.position
end

function Transform:unpackPosition()
	return self.position.x, self.position.y
end


--[[ Rotation ]]

function Transform:rotate(phi)
	self.rotation = self.rotation + phi
	return self
end

function Transform:rotateTo(phi)
	self.rotation = phi
	return self
end

function Transform:getRotation()
	return self.rotation
end


--[[ Scale ]]

-- If one input, sets both the same
function Transform:scaleTo(sx, sy)
	self.scale.x = sx
	self.scale.y = sy or sx
	return self
end

-- If one input, sets both the same
function Transform:addScale(dsx, dsy)
	self.scale.x = self.scale.x + dsx
	self.scale.y = self.scale.y + (dsy or dsx)
	return self
end

function Transform:multiplyScale(multiplier)
	self.scale = self.scale * multiplier
	return self
end

function Transform:getScale()
	return self.scale
end

function Transform:unpackScale()
	return self.scale.x, self.scale.y
end

function Transform:__tostring()
	return "Transform: [ position = " .. tostring(self.position) .. 
					   ", rotation = " .. tostring(self.rotation) .. 
					   ", scale = " .. tostring(self.scale) .."]" 
end
