--[[
	Pretty much a straight-up port of HUMP's Vector class into Middleclass, removing functions I don't use.
	See: https://github.com/vrld/hump/blob/master/Vector3.lua
]]


require 'external.middleclass'

local sqrt, cos, sin, atan2 = math.sqrt, math.cos, math.sin, math.atan2

Vector3 = class('Vector3')

function Vector3:initialize(x, y, z)
	self.x = x or 0
	self.y = y or 0
	self.z = z or 0
end

Vector3.ZERO = Vector3(0,0,0)

function Vector3.isVector3(a)
	return a.class.name == 'Vector3'
end

function Vector3:clone()
	return Vector3(self.x, self.y, self.z)
end

function Vector3:unpack()
	return self.x, self.y, self.z
end

function Vector3:__tostring()
	return "("..tostring(self.x)..","..tostring(self.y)..","..tostring(self.z)..")"
end


function Vector3:add(other)
	assert(Vector3.isVector3(other), 'argument must be a vector')
	self.x = self.x + other.x
	self.y = self.y + other.y
	self.z = self.z + other.z
end

function Vector3:multiply(multiplier)
	assert(type(multiplier) == "number", "argument must be a number, instead is " .. type(multiplier) .. ": " .. tostring(multiplier))
	self.x = self.x * multiplier
	self.y = self.y * multiplier
	self.z = self.z * multiplier

end


function Vector3:__unm()
	return Vector3(-self.x, -self.y, -self.z)
end

function Vector3:__add(other)
	assert(Vector3.isVector3(other), 'argument must be a vector')
	return Vector3(self.x + other.x, self.y + other.y, self.z + other.z)
end

function Vector3:__sub(other)
	assert(Vector3.isVector3(other), 'argument must be a vector')
	return Vector3(self.x - other.x, self.y - other.y, self.z - other.z)
end

function Vector3:__mul(multiplier)
	assert(type(multiplier) == "number", "argument must be a number, instead is " .. type(multiplier) .. ": " .. tostring(multiplier))
	return Vector3(self.x * multiplier, self.y * multiplier, self.z * multiplier)
end

function Vector3:__div(divisor)
	assert(type(divisor) == "number", "argument must be a number")
	return Vector3(self.x / divisor, self.y / divisor, self.z / divisor)
end

function Vector3:__eq(other)
	assert(Vector3.isVector3(other), 'argument must be a vector')
	return self.x == other.x and self.y == other.y and self.z == other.z
end

