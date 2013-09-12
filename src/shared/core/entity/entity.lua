require 'external.middleclass'

Entity = class('Entity')

function Entity:initialize(x, y)

	self.position = Vector(x or 0, y or 0)

	-- Property: active
	-- If false, the sprite will not receive an update-related events and will not be drawn.
	self.active = true

end

function Entity:deactivate()
	self.active = false
end

function Entity:activate()
	self.active = true
end


--[[
function Entity:processInput(dt, input)
	-- Overrided by subclasses
end

function Entity:update(dt)
	-- Overrided by subclasses
end

function Entity:endFrame(dt)
	-- Overrided by subclasses
end
]]