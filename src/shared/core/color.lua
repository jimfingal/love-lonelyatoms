require 'external.middleclass'


Color = class('Color')

function Color:initialize(r, g, b, a)
	self.r = r or 0
	self.g = g or 0
	self.b = b or 0
	self.alpha = a or 255
end


function Color:unpack()
	return self.r, self.g, self.b, self.alpha
end

function Color:__tostring()
	return "Color [r=" .. self.r .. "; g=" .. self.g .. "; b=" .. self.b .. "; a=" .. self.alpha .. "]"
end

function Color.fromHex(hex)

	local r_hex = string.sub(hex, 1, 2)
	local g_hex = string.sub(hex, 3, 4)
	local b_hex = string.sub(hex, 5, 6)

	return Color(tonumber(r_hex, 16), tonumber(g_hex, 16), tonumber(b_hex, 16))

end