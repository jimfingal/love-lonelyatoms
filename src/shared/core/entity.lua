require 'external.middleclass'

Entity = class('Entity')

function Entity:initialize()

	-- Property: active
	-- If false, the sprite will not receive an update-related events and will not be drawn.
	self.active = true

end

function Entity:die()
	self.active = false
end

function Entity:revive()
	self.active = true
end

