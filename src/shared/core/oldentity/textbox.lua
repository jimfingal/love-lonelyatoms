require 'external.middleclass'
require 'core.oldentity.entity'
require 'core.oldentity.shapes'
require 'core.color'
require 'core.mixins.movable'
require 'core.mixins.visible'


TextBox = class("TextBox", Entity)
TextBox:include(Movable)
TextBox:include(Visible)


function TextBox:initialize(text_string, x, y, width, height)

	Entity.initialize(self, x, y)	
	self:movableInit()
	self:visibleInit()

	self.text_string = text_string

	if width and height then
		self.background_box = RectangleShape(x, y, width, height)
		self.background_box:setColor(0, 0, 0, 0)
	end

	self.font = nil
	self.padding = 0

end

function TextBox:setPadding(padding)
	self.padding = padding
end

function TextBox:setFont(font)
	self.font = font
end

function TextBox:setBackgroundColor(r, g, b, a)
	self.background:setColor(r, g, b, a)
end


function TextBox:render(fill_mode)

	if self.background_box then
		self.background_box:draw(fill_mode)
	end

	local previous_font = love.graphics.getFont()

	if self.font then
	    love.graphics.setFont(self.font)

	end
    love.graphics.print(self.text_string, self.position.x + self.padding, self.position.y + self.padding)

    love.graphics.setFont(previous_font)

end