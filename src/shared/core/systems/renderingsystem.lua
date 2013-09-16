require 'external.middleclass'
require 'core.entity.system'
require 'core.components.transform'
require 'core.components.rendering'

RenderingSystem = class('RenderingSystem', System)

function RenderingSystem:initialize()

	System.initialize(self, 'Rendering System')
	self.camera_system = nil
end

function RenderingSystem:setCamera(camera)
	self.camera_system = camera
end

function RenderingSystem:clearCamera()
	self.camera_system = nil
end


function RenderingSystem:renderDrawables(entities)

	if self.camera_system then
		self.camera_system:attach()
	end

	for entity in entities:members() do

        t = entity:getComponent(Transform)
        r = entity:getComponent(Rendering)
       
        self:draw(t, r)
        
    end
	

	if self.camera_system then
		self.camera_system:detach()
	end

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
