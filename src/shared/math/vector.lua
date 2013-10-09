--[[
	Pretty much a straight-up port of HUMP's Vector class into Middleclass, removing functions I don't use.
	See: https://github.com/vrld/hump/blob/master/vector.lua
]]


require 'external.middleclass'

local sqrt, cos, sin, atan2 = math.sqrt, math.cos, math.sin, math.atan2

Vector = class('Vector')

function Vector:initialize(x, y)
	self.x = x or 0
	self.y = y or 0
end

Vector.ZERO = Vector(0,0)


function Vector.isvector(a)
	return a.class.name == 'Vector'
end

function Vector.fromAngle(angle)
	return Vector.fromTheta(math.rad(angle))
end

function Vector.fromTheta(theta)
	return Vector(cos(theta), sin(theta))
end


function Vector:clone()
	return Vector(self.x, self.y)
end

function Vector:unpack()
	return self.x, self.y
end

function Vector:__tostring()
	return "("..tostring(self.x)..","..tostring(self.y)..")"
end


function Vector:add(other)
	assert(Vector.isvector(other), 'argument must be a vector')
	self.x = self.x + other.x
	self.y = self.y + other.y
end

function Vector:multiply(multiplier)
	assert(type(multiplier) == "number", "argument must be a number, instead is " .. type(multiplier) .. ": " .. tostring(multiplier))
	self.x = self.x * multiplier
	self.y = self.y * multiplier
end


--  unary - operation.
-- [[
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
	assert(type(multiplier) == "number", "argument must be a number, instead is " .. type(multiplier) .. ": " .. tostring(multiplier))
	return Vector(self.x * multiplier, self.y * multiplier)
end

function Vector:__div(divisor)
	assert(type(divisor) == "number", "argument must be a number")
	return Vector(self.x / divisor, self.y / divisor)
end

--]]

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

function Vector:rotate(theta)

	local c = math.cos(theta);
	local s = math.sin(theta);

	local new_x = c * self.x - s * self.y
  	local new_y = s * self.x + c * self.y

  	self.x = new_x
  	self.y = new_y

  	return self
end


function Vector:normalize_inplace()
	local l = self:len()
	if l > 0 then
		self.x, self.y = self.x / l, self.y / l
	end
	return self
end

function Vector:normalized()
	return self:clone():normalize_inplace()
end