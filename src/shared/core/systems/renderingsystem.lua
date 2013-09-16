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

	local layers = {}

	local min = math.huge
	local max = 1

	for entity in entities:members() do

		local layer_num = entity:getComponent(Transform):getLayerOrder()
		local layer_set = layers[layer_num]

		if not layer_set then
			layer_set = Set()
			layers[layer_num] = layer_set
		end

		layer_set:add(entity)

		if layer_num < min then
			min = layer_num
		elseif layer_num > max then
			max = layer_num
		end

    end

    if #layers then
	    for i = max, min, -1 do

	    	local layer_set = layers[i]

	    	if layer_set then
	    		for entity in layer_set:members() do
			        t = entity:getComponent(Transform)
			        r = entity:getComponent(Rendering)
			       
			        self:draw(t, r)
	    		end
	    	end
	    end
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
