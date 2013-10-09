require 'external.middleclass'
require 'collections.matrix'
require 'collections.list'
require 'math.vector3'
require 'math.vector2'
require 'pointmass'
require 'spring'

Grid = class('Grid')

local screen_size = Vector2(love.graphics.getWidth(), love.graphics.getHeight())

function Grid:initialize(screen_width, screen_height, rows, cols)

	self.screen_width = screen_width
	self.screen_height = screen_height
	self.rows = rows
	self.cols = cols

	self.x_spacer = self.screen_width / (self.cols - 1)
	self.y_spacer = self.screen_height / (self.rows - 1)


	self.point_grid = Matrix(rows, cols,  nil)
	self.springs = List()

	self.fixed_points = Matrix(rows, cols,  nil)

	for x = 0, cols - 1  do
		for y = 0, rows - 1  do
			self.point_grid:put(x + 1, y + 1, PointMass(x * self.x_spacer, y * self.y_spacer, 0, 1))
			self.fixed_points:put(x + 1, y + 1, PointMass(x * self.x_spacer, y * self.y_spacer, 0, 0))
		end
	end


	local stiffness = 0.28
	local damping = 0.06 

	for x = 1, self.cols do
		for y = 1, self.rows do

			-- anchor the border of the grid 
			if x == 1 or y == 1 or x == self.cols or y == self.rows then

			  	self.springs:append(Spring(self.fixed_points:get(x, y), self.point_grid:get(x, y), 0.1, 0.1))
        
            elseif x % 3 == 0 and y % 3 == 0 then  -- loosely anchor 1/9th of the point masses 
 			  	self.springs:append(Spring(self.fixed_points:get(x, y), self.point_grid:get(x, y), 0.002, 0.002))
 			end


            if x > 1 then
            	self.springs:append(Spring(self.point_grid:get(x - 1, y), self.point_grid:get(x, y), stiffness, damping))
            end

            if y > 1 then
            	self.springs:append(Spring(self.point_grid:get(x, y - 1), self.point_grid:get(x, y), stiffness, damping))
            end

		end
	end


end

function Grid:update(dt)

	for _, spring in self.springs:members() do
		spring:update(dt)
	end

	
	for x = 1, self.cols do
		for y = 1, self.rows do
			self.point_grid:get(x, y):update(dt)
		end
	end

end

function Grid:draw()

	local radius = 4

	for x = 1, self.cols do
		for y = 1, self.rows do
			
			local pointmass = self.point_grid:get(x, y)
			local point = toVec2(pointmass:getPosition())
			
			love.graphics.circle('fill', point.x, point.y, radius)

			-- [[]
			if x > 1 then
				local left = toVec2(self.point_grid:get(x - 1, y):getPosition())
				love.graphics.line(point.x, point.y, left.x, left.y)

				if y % 3 == 1 then
					love.graphics.line(point.x, point.y - 1, left.x, left.y - 1)
					love.graphics.line(point.x, point.y + 1, left.x, left.y + 1)
				end

			end

			if y > 1 then
				local up = toVec2(self.point_grid:get(x, y - 1):getPosition())

				love.graphics.line(point.x, point.y, up.x, up.y)

				if x % 3 == 1 then
					love.graphics.line(point.x - 1, point.y, up.x - 1, up.y)
					love.graphics.line(point.x + 1, point.y, up.x + 1, up.y)
				end

			end
			--]]

			--[[
	 	for (int y = 1; y < height; y++)
	    {
	        for (int x = 1; x < width; x++)      {           
	        	Vector2 left = new Vector2(), up = new Vector2();           
	        	Vector2 p = ToVec2(points[x, y].Position);          
	        	if (x > 1)
	            {
	                left = ToVec2(points[x - 1, y].Position);
	                float thickness = y % 3 == 1 ? 3f : 1f;
	                spriteBatch.DrawLine(left, p, color, thickness);
	            }
	            if (y > 1)
	            {
	                up = ToVec2(points[x, y - 1].Position);
	                float thickness = x % 3 == 1 ? 3f : 1f;
	                spriteBatch.DrawLine(up, p, color, thickness);
	            }
	        }
	    }
	    --]]




		end
	end

end

function toVec2(v3)

	assert(v3.x and v3.y and v3.z, "Must have all three points but instead has " .. tostring(v3))
	-- do a perspective projection
	local factor = (v3.z + 2000) / 2000

	local proj = Vector2(v3.x, v3.y)
	proj = proj - (screen_size / 2)
	proj = proj * factor
	proj = proj + (screen_size / 2)

	return proj

end
