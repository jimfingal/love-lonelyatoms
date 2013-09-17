require 'external.middleclass'
require 'core.oldentity.entity'
require 'core.oldentity.shapes'
require 'core.color'
require 'core.mixins.movable'
require 'core.mixins.visible'


TextBox = class("TextBox", Component)

--[[ TODO Convert ]]
function TextBox:initialize(text_string)

	Component.initialize(self, 'TextBox')

	self.text_string = text_string
	self.padding = 0
	self.font = nil
	self.color = Color(0, 0, 0, 255)
end

function TextBox:setPadding(padding)
	self.padding = padding
end

function TextBox:setFont(font)
	self.font = font
end

function TextBox:setColor(r, g, b, a)
	self.color = Color(r, g, b, a)
	return self
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