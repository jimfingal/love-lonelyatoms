require 'external.middleclass'
require 'core.entity.system'

RenderingSystem = class('RenderingSystem', System)

function RenderingSystem:initialize()

	System.initialize(self, 'Rendering System')

end


function RenderingSystem:draw(transform, rendering)

	if rendering:isVisible() then
		
		local img = rendering:getImg()
		local shape = rendering:getShape()

		assert(img or shape, "Must have either an image or shape to be drawn")

		-- Check the previous color settings
		local r, g, b, a = love.graphics.getColor()
		
		local color = rendering:getColor()

		love.graphics.setColor(color:unpack())

		if img then -- Render image
			
		else -- Render shape
			
			local pos = transform:getPosition() + shape:offset()

			shape:draw(pos, rendering:getFillMode())

		end

		-- Restore the previous color settings
		love.graphics.setColor(r, g, b, a)

	end

end
