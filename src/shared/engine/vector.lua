require 'class.middleclass'

local sqrt, cos, sin, atan2 = math.sqrt, math.cos, math.sin, math.atan2

Vector = class('Vector')

function Vector:initialize(x, y)
	self.x = x or 0
	self.y = y or 0
end

local zero = Vector(0,0)

function Vector.isvector(a)
	return a.class.name == 'Vector'
end

function Vector:clone()
	return Vector(self.x, self.y)
end

function Vector:unpack()
	return self.x, self.y
end

function Vector:__tostring()
	return "("..tonumber(self.x)..","..tonumber(self.y)..")"
end

--  unary - operation.
function Vector:__unm()
	return Vector(-self.x, -self.y)
end

function Vector:__add(other)
	assert(Vector.isvector(other), 'argument must be a vector')
	return Vector(self.x + other.x, self.y + other.y)
end

function Vector:__sub(other)
	assert(Vector.isvector(other), 'argument must be a vector')
	return Vector(self.x - other.x, self.y - other.y)
end

function Vector:__mul(multiplier)
	assert(type(multiplier) == "number", "argument must be a number")
	return Vector(self.x * multiplier, self.y * multiplier)
end

function Vector:__div(divisor)
	assert(type(divisor) == "number", "argument must be a number")
	return Vector(self.x / divisor, self.y / divisor)
end

function Vector:__eq(other)
	assert(Vector.isvector(other), 'argument must be a vector')
	return self.x == other.x and self.y == other.y
end

function Vector:__lt(other)
	assert(Vector.isvector(other), 'argument must be a vector')
	return self.x < other.x or (self.x == other.x and self.y < other.y)
end

function Vector:__le(other)
	assert(Vector.isvector(other), 'argument must be a vector')
	return self.x <= other.x and self.y <= other.y
end


function Vector:len2()
	return self.x * self.x + self.y * self.y
end

function Vector:len()
	return sqrt(self.x * self.x + self.y * self.y)
end

function Vector.dist(a, b)
	assert(Vector.isvector(a) and Vector.isvector(b), "dist: wrong argument types (<vector> expected)")
	local dx = a.x - b.x
	local dy = a.y - b.y
	return sqrt(dx * dx + dy * dy)
end

function Vector.dist2(a, b)
	assert(Vector.isvector(a) and Vector.isvector(b), "dist: wrong argument types (<vector> expected)")
	local dx = a.x - b.x
	local dy = a.y - b.y
	return (dx * dx + dy * dy)
end

function Vector:normalize_inplace()
	local l = self:len()
	if l > 0 then
		self.x, self.y = self.x / l, self.y / l
	end
	return self
end

--[[
function vector:normalized()
	return self:clone():normalize_inplace()
end

function vector:rotate_inplace(phi)
	local c, s = cos(phi), sin(phi)
	self.x, self.y = c * self.x - s * self.y, s * self.x + c * self.y
	return self
end

function vector:rotated(phi)
	local c, s = cos(phi), sin(phi)
	return new(c * self.x - s * self.y, s * self.x + c * self.y)
end

function vector:perpendicular()
	return new(-self.y, self.x)
end

function vector:projectOn(v)
	assert(isvector(v), "invalid argument: cannot project vector on " .. type(v))
	-- (self * v) * v / v:len2()
	local s = (self.x * v.x + self.y * v.y) / (v.x * v.x + v.y * v.y)
	return new(s * v.x, s * v.y)
end

function vector:mirrorOn(v)
	assert(isvector(v), "invalid argument: cannot mirror vector on " .. type(v))
	-- 2 * self:projectOn(v) - self
	local s = 2 * (self.x * v.x + self.y * v.y) / (v.x * v.x + v.y * v.y)
	return new(s * v.x - self.x, s * v.y - self.y)
end

function vector:cross(v)
	assert(isvector(v), "cross: wrong argument types (<vector> expected)")
	return self.x * v.y - self.y * v.x
end

-- ref.: http://blog.signalsondisplay.com/?p=336
function vector:trim_inplace(maxLen)
	local s = maxLen * maxLen / self:len2()
	s = s < 1 and 1 or math.sqrt(s)
	self.x, self.y = self.x * s, self.y * s
	return self
end

function vector:angleTo(other)
	other = other or zero
	return atan2(self.y - other.y, self.x - other.x)
end

function vector:trimmed(maxLen)
	return self:clone():trim_inplace(maxLen)
end


-- the module
return setmetatable({new = new, isvector = isvector, zero = zero},
{__call = function(_, ...) return new(...) end})

--]]