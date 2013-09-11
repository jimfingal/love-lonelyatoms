require 'engine.vector'

Movable = {}

function Movable.movableInit(self, x, y)

	-- Property: Position. 
	-- x == 0 is the left edge of the window.
	-- y == 0 is the top edge of the window.

	self.position = Vector(x or 0, y or 0)

	-- Property: rotation
	-- Rotation of drawn sprite in radians.
	self.rotation = 0

end

function Movable.position(self)
	return self.position
end

function Movable.moveTo(self, x, y)
	self.position.x = x;
	self.position.y = y;
end

function Movable.move(self, dx, dy)
	self.position.x = self.position.x + dx;
	self.position.y = self.position.y + dy;
end
