require 'external.middleclass'
require 'core.entity.system'

RenderingSystem = class('RenderingSystem', System)

function RenderingSystem:initialize()

	System.initialize(self, 'Rendering System')

end


function RenderingSystem:draw(transform, rendering)

	if rendering.visible then
		
		-- Check the previous color settings
		local r, g, b, a = love.graphics.getColor()
		
		local color = rendering:getColor()

		love.graphics.setColor(color:unpack())

		
		if rendering:getImg() then -- Render image
			
		else -- Render shape
			
			local shape = rendering:getShape()
			
			local pos = transform:getPosition() + shape:offset()

			shape:draw(pos, rendering:getFillMode())

		end

		-- Restore the previous color settings
		love.graphics.setColor(r, g, b, a)

	end

end
