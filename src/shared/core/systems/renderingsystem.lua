require 'external.middleclass'
require 'core.entity.system'
require 'core.components.transform'
require 'core.components.rendering'

RenderingSystem = class('RenderingSystem', System)

function RenderingSystem:initialize()

	System.initialize(self, 'Rendering System')
	self.camera_system = nil
	self.canvas = love.graphics.newCanvas()
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
			        self:draw(entity)
	    		end
	    	end
	    end
	end
	

	if self.camera_system then
		self.camera_system:detach()
	end

end


-- TODO, fix magic strings

local RenderingFunctions = {

	shape = function(transform, rendering) 
			
			local shape = rendering:getShape()
			local fill = rendering:getFillMode()

			local shape_center = shape:center(transform:getPosition())

			love.graphics.push()
			love.graphics.translate(shape_center.x, shape_center.y)
			love.graphics.rotate(transform:getRotation())
			love.graphics.scale(transform:unpackScale())

			shape:drawAroundOrigin(fill)

			love.graphics.pop()

	end, 

	text = function(transform, rendering) 

		local previous_font = love.graphics.getFont()

		if rendering:getFont() then
		    love.graphics.setFont(rendering:getFont())
		end

		love.graphics.push()
		love.graphics.translate(transform:getPosition().x + rendering:getPadding(), 
								transform:getPosition().y + rendering:getPadding())
		love.graphics.rotate(transform:getRotation())
		love.graphics.scale(transform:unpackScale())

	    love.graphics.print(rendering:getText(), 0, 0)

		love.graphics.pop()


	    if previous_font then 
	    	love.graphics.setFont(previous_font)
	    end
	    
	end, 

	image = function() 

		local img = rendering:getImg()
		
		-- TODO
	end
}



function RenderingSystem:draw(entity)


	local transform = entity:getComponent(Transform)

	local rendering = nil

	if entity:hasComponent(ShapeRendering) then
		rendering = entity:getComponent(ShapeRendering)
	elseif entity:hasComponent(TextRendering) then
		rendering = entity:getComponent(TextRendering)
	elseif entity:hasComponent(ImageRendering) then
		rendering = entity:getComponent(ImageRendering)
	end

	assert (rendering, "Unable to get a rendering from " .. tostring(entity))

	if rendering:isVisible() then
		
		-- Check the previous color settings
		local r, g, b, a = love.graphics.getColor()
		
		local color = rendering:getColor()

		love.graphics.setColor(color:unpack())

		local draw_action = RenderingFunctions[rendering.render_type]
		draw_action(transform, rendering)

		-- Restore the previous color settings
		love.graphics.setColor(r, g, b, a)

	end

end
