require 'external.middleclass'
require 'core.color'
require 'core.mixins.movable'


Rendering = class('Rendering', Component)

function Rendering:initialize()

	Component.initialize(self, 'Rendering')

	self.visible = true
	self.img = nil
	self.color = Color(0, 0, 0, 255)
	self.fill_mode = 'fill'
	
	-- TODO: this should be a group of things that have color or background
	self.shape_data = nil


end

function Rendering:setShape(shape_data)
	self.shape_data = shape_data
	return self
end

function Rendering:getShape()
	return self.shape_data
end

function Rendering:setImg(img)
	self.img = img
	return self
end

function Rendering:getImg()
	return self.img
end


function Rendering:setColor(r, g, b, a)
	self.color = Color(r, g, b, a)
	return self
end

function Rendering:getColor()
	return self.color
end

function Rendering:setFillMode(fm)
	self.fill_mode = fm
	return self
end

function Rendering:getFillMode()
	return self.fill_mode
end

function Rendering:isVisible()
	return self.visible
end

function Rendering:enable()
	self.visible = true
	return self
end

function Rendering:disable()
	self.visible = false
	return self
end
