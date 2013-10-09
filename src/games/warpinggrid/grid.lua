require 'external.middleclass'
require 'collections.matrix'
require 'collections.list'
require 'math.vector3'
require 'math.vector2'
require 'pointmass'
require 'spring'

Grid = class('Grid')

local half_screen_size = Vector2(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)

function Grid:initialize(screen_width, screen_height, cols, rows)

	self.screen_width = screen_width
	self.screen_height = screen_height

	self.cols = cols
	self.rows = rows

	self.x_spacer = self.screen_width / (self.cols - 1)
	self.y_spacer = self.screen_height / (self.rows - 1)


	self.point_grid = Matrix(cols, rows,  nil)
	self.springs = List()

	self.fixed_points = Matrix(cols, rows,  nil)

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

local point = Vector2(0, 0)
local left = Vector2(0, 0)
local up = Vector2(0, 0)

function Grid:draw()

	local radius = 4

	for x = 1, self.cols do
		for y = 1, self.rows do
			
			local pointmass = self.point_grid:get(x, y)
			point = toVec2(pointmass:getPosition(), point)
			
			--love.graphics.point('fill', point.x, point.y, radius)

			-- [[]
			if x > 1 then
				left = toVec2(self.point_grid:get(x - 1, y):getPosition(), left)
				love.graphics.line(point.x, point.y, left.x, left.y)

				--[[
				if y % 3 == 1 then
					love.graphics.line(point.x, point.y - 1, left.x, left.y - 1)
					love.graphics.line(point.x, point.y + 1, left.x, left.y + 1)
				end
				]]
			end

			if y > 1 then
				up = toVec2(self.point_grid:get(x, y - 1):getPosition(), up)

				love.graphics.line(point.x, point.y, up.x, up.y)

				--[[
				if x % 3 == 1 then
					love.graphics.line(point.x - 1, point.y, up.x - 1, up.y)
					love.graphics.line(point.x + 1, point.y, up.x + 1, up.y)
				end
				]]
			end
			--]]

		end
	end

end

function toVec2(v3, v2)

	assert(v3.x and v3.y and v3.z, "Must have all three points but instead has " .. tostring(v3))
	-- do a perspective projection
	local factor = (v3.z + 2000) / 2000

	v2.x = v3.x
	v2.y = v3.y
	v2:subtract(half_screen_size)
	v2:multiply(factor)
	v2:add(half_screen_size)

	return v2

end


local _force_buffer = Vector3(0, 0, 0)

function Grid:applyImplosiveForce(force, position, radius)

	for x = 1, self.cols do
		for y = 1, self.rows do
			
			local point = self.point_grid:get(x, y)

			local distance_from_point = Vector3.distance2(position, point:getPosition())

			if distance_from_point < radius * radius then

				_force_buffer:copy(position)
				_force_buffer:subtract(point:getPosition())
				_force_buffer:multiply(10 * force)
				_force_buffer:divide(100 + distance_from_point)

				point:applyForce(_force_buffer)
				point:increaseDamping(0.6)
			end

		end
	end

end

function Grid:applyExplosiveForce(force, position, radius)

	for x = 1, self.cols do
		for y = 1, self.rows do
			
			local point = self.point_grid:get(x, y)

			local distance_from_point = Vector3.distance2(position, point:getPosition())

			if distance_from_point < radius * radius then

				_force_buffer:copy(position)
				_force_buffer:subtract(point:getPosition())
				_force_buffer:multiply(100 * force)
				_force_buffer:divide(10000 + distance_from_point)

				point:applyForce(_force_buffer)
				point:increaseDamping(0.6)

			end

		end
	end

end

