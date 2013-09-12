require 'core.vector'

Scalable = {}

function Scalable.scalableInit(self, x, y)

	self.s = Vector(x or 1, y or 1)

end


-- If one input, sets both the same
function Scalable.scaleTo(self, sx, sy)
	self.s.x = sx
	self.s.y = sy or sx
end

-- If one input, sets both the same
function Scalable.addScale(self, dsx, dsy)
	self.s.x = self.s.x + dsx
	self.s.y = self.s.y + (dsy or dsx)
end

function Scalable.multiplyScale(self, multiplier)
	self.s = self.s * multiplier
end


function Scalable.getScale(self)
	return self.s
end

function Scalable.unpackScale(self)
	return self.s.x, self.s.y
end
 