require 'external.middleclass'

Entity = class('Entity')

function Entity:initialize(name)
	assert(name, "must have a name")

	self.name = name

	-- Property: active
	-- If false, the sprite will not receive an update-related events.
	self.active = true

	-- Property: visible
	-- If false, the sprite will not draw itself onscreen.
	self.visible = true

end

function Entity:die()
	self.active = false
	self.visible = false
end

function Entity:revive()
	self.active = true
	self.visible = true
end

