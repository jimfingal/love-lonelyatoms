require 'class.middleclass'
require 'engine.vector'

Transform = class('Transform')


function Transform:initialize()

	-- Property: Position. 
	-- x == 0 is the left edge of the window.
	-- y == 0 is the top edge of the window.

	self.position = Vector(0, 0)

	-- Property: rotation
	-- Rotation of drawn sprite in radians. This does not affect the bounds
	-- used during collision checking.
	self.rotation = 0

	-- Property: scale
	-- This affects how the sprite is drawn onscreen. e.g. a sprite with scale 2 will
	-- display twice as big. Scaling is centered around the sprite's center. This has
	-- no effect on collision detection.
	self.scale = 1

end

function Transform:moveTo(x, y)
	self.position.x = x;
	self.position.y = y;
end


function Transform:__tostring()
	return "( position: " .. tostring(self.position) .. 
		", rotation: " .. tonumber(self.rotation) .. 
		", scale: " .. tonumber(self.scale) .. " )"
end