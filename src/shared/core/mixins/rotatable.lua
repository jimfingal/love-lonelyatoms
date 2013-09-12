require 'core.vector'

Rotatable = {}

function Rotatable.rotatableInit(self)

	-- Property: rotation
	-- Rotation of drawn sprite in radians.
	self.rotation = 0

end


-- Radians
function Rotatable.rotate(self, phi)
	self.rotation = self.rotation + phi
end

-- Radians
function Rotatable:rotateTo(self, phi)
	self.rotation = phi
end
