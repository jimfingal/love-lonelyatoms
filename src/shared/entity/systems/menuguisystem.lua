require 'external.middleclass'
require 'entity.system'
require 'entity.components.menugui'

MenuGuiSystem = class('MenuGuiSystem', System)

function MenuGuiSystem:initialize(world)

	System.initialize(self, 'Menu System')
	self.world = world

end



function MenuGuiSystem:drawMenu(menu)

	love.graphics.setFont(menu.font)

	local x_index = menu.x
	local y_index = menu.y

	for i, item in menu.menu_items:members() do

		if i == menu.selected_index then
			love.graphics.setColor(menu.highlight_color:unpack())
		else
			love.graphics.setColor(menu.text_color:unpack())
		end

		love.graphics.print(item.text, x_index, y_index)

		y_index = y_index + menu.line_height + menu.line_spacing

	end

end