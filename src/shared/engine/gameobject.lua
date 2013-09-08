require 'external.middleclass'

GameObject = class('GameObject')

function GameObject:initialize(name)
	assert(name, "must have a name")

	self.name = name

	-- Property: active
	-- If false, the sprite will not receive an update-related events.
	self.active = true

	-- Property: visible
	-- If false, the sprite will not draw itself onscreen.
	self.visible = true

end

function GameObject:die()
	self.active = false
	self.visible = false
end

function GameObject:revive()
	self.active = true
	self.visible = true
end

