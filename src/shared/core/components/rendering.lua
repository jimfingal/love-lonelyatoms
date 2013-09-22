require 'external.middleclass'
require 'core.color'
require 'core.entity.component'



-- [[ TODO, don't like this. Should be able to just ask for Rendering component. Perhaps have factory and private member containing data?]]
local Rendering = class('Rendering', Component)

Rendering.SHAPE = "shape"
Rendering.TEXT = "text"
Rendering.IMAGE = "image"


function Rendering:initialize(render_type)

	Component.initialize(self, 'Rendering')

	self.visible = true
	self.render_type = render_type

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


--[[ Shape ]]

ShapeRendering = class('ShapeRendering', Rendering)

function ShapeRendering:initialize()
	
	Rendering.initialize(self, Rendering.SHAPE)

	self.color = Color(0, 0, 0, 255)
	self.fill_mode = 'fill'
	
	-- TODO: this should be a group of things that have color or background
	self.shape_data = nil
end


function ShapeRendering:setShape(shape_data)
	self.shape_data = shape_data
	return self
end

function ShapeRendering:getShape()
	return self.shape_data
end

function ShapeRendering:setColor(r, g, b, a)
	self.color = Color(r, g, b, a)
	return self
end

function ShapeRendering:getColor()
	return self.color
end

function ShapeRendering:setFillMode(fm)
	self.fill_mode = fm
	return self
end

function ShapeRendering:getFillMode()
	return self.fill_mode
end


function ShapeRendering:__tostring()
	return "Component: Shape Rendering :: " .. tostring(self:getShape()) -- TOOD more
end

--[[ Text ]]

TextRendering = class('TextRendering', Rendering)

function TextRendering:initialize(text)

	Rendering.initialize(self, Rendering.TEXT)

	self.text = text
	self.color = Color(0, 0, 0, 255)
	self.padding = 0
	self.font = nil

end

function TextRendering:setText(text)
	self.text = text
	return self
end

function TextRendering:getText()
	return self.text
end

function TextRendering:setColor(r, g, b, a)
	self.color = Color(r, g, b, a)
	return self
end

function TextRendering:getColor()
	return self.color
end

function TextRendering:setPadding(padding)
	self.padding = padding
	return self
end

function TextRendering:getPadding()
	return self.padding
end

function TextRendering:setFont(font)
	self.font = font
	return self
end

function TextRendering:getFont()
	return self.font
end

function TextRendering:__tostring()
	return "Component: Text Rendering :: " .. self:getText() -- TOOD more
end


--[[ Image ]]

ImageRendering = class('ImageRendering', Rendering)

function ImageRendering:initialize()

	Rendering.initialize(self, Rendering.IMAGE)

	self.img = nil

end

function ImageRendering:setImg(img)
	self.img = img
	return self
end

function ImageRendering:getImg()
	return self.img
end
