require 'external.middleclass'
require 'collections.list'
require 'game.color'
require 'entity.component'



MenuGui = class("MenuGui", Component)

function MenuGui:initialize(x, y, world)

	Component.initialize(self, "MenuGui")

--[[
	Entity.initialize(self, x, y)


	self.background = RectangleShape(x, y, width, height)
]]

	self.x = x
	self.y = y

	self.menu_items = List()

	self.line_height = 0
	self.line_spacing = 0

	self.selected_index = nil

	self.font = nil
	self.text_color = nil
	self.highlight_color = nil

	self.world = world

end

function MenuGui:setTextColor(r, g, b, a)
	self.text_color = Color(r, g, b, a)
end

function MenuGui:setHighlightColor(r, g, b, a)
	self.highlight_color = Color(r, g, b, a)
end

function MenuGui:setFont(font, line_height)

	self.font = font

	self.line_height = line_height
	self.line_spacing = line_height / 2

end


function MenuGui:loopSelectedIndex()

	if self.selected_index > self.menu_items:size() then
		self.selected_index = 1
	elseif self.selected_index < 1 then
		self.selected_index = self.menu_items:size()
	end

end


function MenuGui:addMenuItem(text, select_callback, hightlight_callback)

	local mi = MenuGuiItem(text, select_callback, hightlight_callback)
	self.menu_items:append(mi)

end


function MenuGui:highlightMenuItem(index)

	local item = self.menu_items:memberAt(index)

	if item.highlight_callback then 
		item:highlight_callback()
	end

end

function MenuGui:selectMenuItem(index, state_manager)

	local item = self.menu_items:memberAt(index)
	item.select_callback(state_manager)

end



MenuGuiItem = class("MenuGuiItem")

function MenuGuiItem:initialize(text, select_callback, highlight_callback)

	self.text = text
	self.select_callback = select_callback
	self.highlight_callback = highlight_callback

end
