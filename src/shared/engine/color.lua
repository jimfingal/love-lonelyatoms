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