require 'external.middleclass'
require 'core.color'
require 'core.mixins.movable'


Rendering = class('Rendering', Component)

function Rendering:initialize()

	self.visible = true
	self.img = nil
	self.color = Color(0, 0, 0, 255)
	self.background_color = Color(0, 0, 0, 255)
	self.fill_mode = 'fill'
	
	-- TODO: this should be a group of things that have color or background
	self.shape_data = nil


end

function Rendering:setShape(shape_data)
	self.shape_data = shape_data
end

function Rendering:setImg(img)
	self.img = img
end

function Rendering:setColor(r, g, b, a)
	self.color = Color(r, g, b, a)
end

function Rendering:setBackgroundColor(r, g, b, a)
	self.background_color = Color(r, g, b, a)
end

function Rendering:setFillMode(self, fm)
	self.fill_mode = fm
end

function Rendering:enable()
	self.visible = true
end

function Rendering:disable()
	self.visible = false
end
