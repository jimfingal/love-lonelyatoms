
require 'external.middleclass'
require 'collections.list'
require 'engine.shapes'
require 'engine.input'

SimpleMenu = class("SimpleMenu", GameObject)

local MENU_UP = "up"
local MENU_DOWN = "down"
local MENU_SELECT = "select"

function SimpleMenu:initialize(x, y, width, height)

	self.menu_items = List()

	self.background = RectangleShape(x, y, width, height)

	self.line_height = 0
	self.line_spacing = 0

	self.selected_index = 1

	self.font = nil
	self.background_color = nil
	self.text_color = nil
	self.highlight_color = nil

	self.input = InputManager()

    self.input:registerInput('up', MENU_UP)
    self.input:registerInput('down', MENU_DOWN)
    self.input:registerInput('return', MENU_SELECT)

end

function SimpleMenu:setBackgroundColor(r, g, b, a)
	self.background_color = Color(r, g, b, a)
end

function SimpleMenu:setTextColor(r, g, b, a)
	self.text_color = Color(r, g, b, a)
end

function SimpleMenu:setHighlightColor(r, g, b, a)
	self.highlight_color = Color(r, g, b, a)
end

function SimpleMenu:update(dt, state_manager)
	
	self.input:update(dt)

	if self.input:newAction(MENU_UP) then

		self.selected_index = self.selected_index - 1
		self:loopSelectedIndex()
		self:highlightMenuItem(self.selected_index)

	elseif self.input:newAction(MENU_DOWN) then

		self.selected_index = self.selected_index + 1
		self:loopSelectedIndex()
		self:highlightMenuItem(self.selected_index)

	elseif self.input:newAction(MENU_SELECT) then

		self:selectMenuItem(self.selected_index, state_manager)

	end


end

function SimpleMenu:loopSelectedIndex()

	if self.selected_index > self.menu_items:size() then
		self.selected_index = 1
	elseif self.selected_index < 1 then
		self.selected_index = self.menu_items:size()
	end

end


function SimpleMenu:setFont(font, line_height)

	self.font = font

	self.line_height = line_height
	self.line_spacing = line_height / 2

end


function SimpleMenu:addMenuItem(text, select_callback, hightlight_callback)

	local mi = SimpleMenuItem(text, select_callback, hightlight_callback)
	self.menu_items:append(mi)

end


function SimpleMenu:highlightMenuItem(index)

	local item = self.menu_items:memberAt(index)

	if item.highlight_callback then 
		item:highlight_callback()
	end

end

function SimpleMenu:selectMenuItem(index, state_manager)

	local item = self.menu_items:memberAt(index)
	item.select_callback(state_manager)

end


function SimpleMenu:draw()

	love.graphics.setColor(self.background_color:unpack())
	self.background:draw('fill')

	love.graphics.setFont(self.font)

	local x_index = self.background.upper_left.x
	local y_index = self.background.upper_left.y

	for i, item in self.menu_items:members() do

		if i == self.selected_index then
			love.graphics.setColor(self.highlight_color:unpack())
		else
			love.graphics.setColor(self.text_color:unpack())
		end

		love.graphics.print(item.text, x_index, y_index)

		y_index = y_index + self.line_height + self.line_spacing

	end

	love.graphics.print(self.selected_index, x_index, y_index)

end



SimpleMenuItem = class("SimpleMenuItem", GameObject)

function SimpleMenuItem:initialize(text, select_callback, highlight_callback)

	self.text = text
	self.select_callback = select_callback
	self.highlight_callback = highlight_callback

end
