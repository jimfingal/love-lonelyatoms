--[[
	Pretty much a straight-up port of HUMP's Vector class into Middleclass, removing functions I don't use.
	https://github.com/vrld/hump/blob/master/vector.lua
	His copyright is:
]]

--[[
Copyright (c) 2010-2013 Matthias Richter

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

Except as contained in this notice, the name(s) of the above copyright holders
shall not be used in advertising or otherwise to promote the sale, use or
other dealings in this Software without prior written authorization.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]--

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

function Vector:clone()
	return Vector(self.x, self.y)
end

function Vector:unpack()
	return self.x, self.y
end

function Vector:__tostring()
	return "("..tostring(self.x)..","..tostring(self.y)..")"
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
	assert(type(multiplier) == "number", "argument must be a number, instead is " .. type(multiplier) .. ": " .. tostring(multiplier))
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

function Vector:normalized()
	return self:clone():normalize_inplace()
end