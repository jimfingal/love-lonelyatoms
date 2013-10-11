--[[
	Pretty much a straight-up port of HUMP's Vector class into Middleclass, removing functions I don't use.
	See: https://github.com/vrld/hump/blob/master/Vector2.lua
]]


require 'external.middleclass'

local sqrt, cos, sin, atan2 = math.sqrt, math.cos, math.sin, math.atan2

Vector2 = class('Vector2')

local STRICT = false

function Vector2:initialize(x, y)
	self.x = x or 0
	self.y = y or 0
end

Vector2.ZERO = Vector2(0,0)

function Vector2:zero()
	self.x = 0
	self.y = 0
end

function Vector2.isVector2(a)
	return a.class.name == 'Vector2'
end

function Vector2.fromAngle(angle)
	return Vector2.fromTheta(math.rad(angle))
end

function Vector2.fromTheta(theta)
	return Vector2(cos(theta), sin(theta))
end

function Vector2:toTheta()
	return math.atan2(self.y, self.x)
end


function Vector2:copy(other)
	self.x = other.x
	self.y = other.y
end

function Vector2:clone()
	return Vector2(self.x, self.y)
end

function Vector2:unpack()
	return self.x, self.y
end

function Vector2:__tostring()
	return "("..tostring(self.x)..","..tostring(self.y)..")"
end


function Vector2:add(other)
	if STRICT then assert(Vector2.isVector2(other), 'argument must be a vector') end
	self.x = self.x + other.x
	self.y = self.y + other.y
end


function Vector2:subtract(other)
	if STRICT then assert(Vector2.isVector2(other), 'argument must be a vector') end
	self.x = self.x - other.x
	self.y = self.y - other.y
end

function Vector2:multiply(multiplier)
	if STRICT then assert(type(multiplier) == "number", "argument must be a number, instead is " .. type(multiplier) .. ": " .. tostring(multiplier)) end
	self.x = self.x * multiplier
	self.y = self.y * multiplier
end

function Vector2:negative()
	self.x = -self.x
	self.y = -self.y
end


--  unary - operation.
-- [[
function Vector2:__unm()
	return Vector2(-self.x, -self.y)
end

function Vector2:__add(other)
	assert(Vector2.isVector2(other), 'argument must be a vector')
	return Vector2(self.x + other.x, self.y + other.y)
end

function Vector2:__sub(other)
	assert(Vector2.isVector2(other), 'argument must be a vector')
	return Vector2(self.x - other.x, self.y - other.y)
end

function Vector2:__mul(multiplier)
	assert(type(multiplier) == "number", "argument must be a number, instead is " .. type(multiplier) .. ": " .. tostring(multiplier))
	return Vector2(self.x * multiplier, self.y * multiplier)
end

function Vector2:__div(divisor)
	assert(type(divisor) == "number", "argument must be a number")
	return Vector2(self.x / divisor, self.y / divisor)
end

--]]

function Vector2:__eq(other)
	assert(Vector2.isVector2(other), 'argument must be a vector')
	return self.x == other.x and self.y == other.y
end


--[[
function Vector2:__lt(other)
	assert(Vector2.isVector2(other), 'argument must be a vector')
	return self.x < other.x or (self.x == other.x and self.y < other.y)
end

function Vector2:__le(other)
	assert(Vector2.isVector2(other), 'argument must be a vector')
	return self.x <= other.x and self.y <= other.y
end



function Vector2:__le(other)
	assert(Vector2.isVector2(other), 'argument must be a vector')
	return self:len2() <= other:len2()
end
]]

function Vector2:__lt(other)
	assert(Vector2.isVector2(other), 'argument must be a vector')
	return self:len2() < other:len2()
end



function Vector2:len2()
	return self.x * self.x + self.y * self.y
end

function Vector2:len()
	return sqrt(self.x * self.x + self.y * self.y)
end

function Vector2.dist(a, b)
	assert(Vector2.isVector2(a) and Vector2.isVector2(b), "dist: wrong argument types (<vector> expected)")
	local dx = a.x - b.x
	local dy = a.y - b.y
	return sqrt(dx * dx + dy * dy)
end

function Vector2.dist2(a, b)
	assert(Vector2.isVector2(a) and Vector2.isVector2(b), "dist: wrong argument types (<vector> expected)")
	local dx = a.x - b.x
	local dy = a.y - b.y
	return (dx * dx + dy * dy)
end

function Vector2:rotate(theta)

	local c = math.cos(theta);
	local s = math.sin(theta);

	local new_x = c * self.x - s * self.y
  	local new_y = s * self.x + c * self.y

  	self.x = new_x
  	self.y = new_y

  	return self
end


function Vector2:normalize_inplace()
	self.x, self.y = self:normalized_values()
	return self
end

function Vector2:normalized()
	return self:clone():normalize_inplace()
end

function Vector2:normalized_values()
	local l = self:len()
	if l > 0 then
		return self.x / l, self.y / l
	end
	return self.x, self.y
end


function Vector2:scaleTo(distance)
	self:normalize_inplace()
	self:multiply(distance)
	return self
end

function Vector2:setToDifference(position, target)

	self:copy(target)
	self:subtract(position)

	return self

end


function Vector2:zero()
	self.x = 0
	self.y = 0
end
