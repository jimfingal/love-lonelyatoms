EmissionPort = class("EmissionPort")

function EmissionPort:initialize()
	self.offset = Vector2(0, 0)
	self.rotation = 0
end

function EmissionPort:setOffset(x, y)
	self.offset.x = x
	self.offset.y = y
end

function EmissionPort:getOffset()
	return self.offset
end

function EmissionPort:setRotation(theta)
	self.rotation = theta
end

function EmissionPort:getRotation()
	return self.rotation
end