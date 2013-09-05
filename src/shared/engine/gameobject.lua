require 'class.middleclass'

GameObject = class('GameObject')

function GameObject:initialize(name)
	assert(name, "must have a name")

	self.name = name

	self.rigid_body = nil
	
	self.transform = nil

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
	self.solid = false
end

function GameObject:revive()
	self.active = true
	self.visible = true
	self.solid = true
end

