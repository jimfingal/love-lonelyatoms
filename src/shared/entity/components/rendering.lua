require 'external.middleclass'
require 'game.color'
require 'entity.component'
require 'collections.list'



-- [[ TODO, don't like this. Should be able to just ask for Rendering component. Perhaps have factory and private member containing data?]]
Rendering = class('Rendering', Component)

function Rendering:initialize()

	Component.initialize(self, 'Rendering')

	self.active = true
	self.sub_components = List()
	self.key_components = {}
end

function Rendering:isActive()
	return self.active
end

function Rendering:enable()
	self.active = true
	return self
end

function Rendering:disable()
	self.active = false
	return self
end

function Rendering:addRenderable(renderable, key)
	
	self.sub_components:append(renderable)

	-- If there are multiple components, support keyed access.
	if key then
		self.key_components[key] = renderable
	end

	return self
end

function Rendering:getRenderables()
	return self.sub_components
end

function Rendering:getRenderable(key)
	if not key and self.sub_components:size() == 1 then
		return self.sub_components:memberAt(1)
	else
		return self.key_components[key]
	end
end

local Renderable = class('Renderable')

function Renderable:initialize(render_type)
	self.active = true
	self.render_type = render_type
end

Renderable.SHAPE = "shape"
Renderable.TEXT = "text"
Renderable.IMAGE = "image"


function Renderable:isActive()
	return self.active
end

function Renderable:enable()
	self.active = true
	return self
end

function Renderable:disable()
	self.active = false
	return self
end


--[[ Shape ]]

ShapeRendering = class('ShapeRendering', Renderable)

function ShapeRendering:initialize()
	
	Renderable.initialize(self, Renderable.SHAPE)

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
	return "Component: Shape Rendering :: " .. tostring(self:getShape()) .. ", Color: " .. tostring(self:getColor()) -- TOOD more
end

--[[ Text ]]

TextRendering = class('TextRendering', Renderable)

function TextRendering:initialize(text)

	Renderable.initialize(self, Renderable.TEXT)

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

ImageRendering = class('ImageRendering', Renderable)

function ImageRendering:initialize()

	Renderable.initialize(self, Renderable.IMAGE)

	self.img = nil

end

function ImageRendering:setImg(img)
	self.img = img
	return self
end

function ImageRendering:getImg()
	return self.img
end
