require 'math.vector2'
require 'external.middleclass'

Shape = class('Shape')

function Shape:initialize(x, y)
	
	-- Shapes are used as hitboxes or for rendering.
	-- Position offset is how far to offset from the entity's Transform.

	self.position_offset = Vector2(x or 0, y or 0)

end

function Shape:offset()
	return self.position_offset
end

-- [[ Circles ]]

CircleShape = class('CircleShape', Shape)

function CircleShape:initialize(radius, x, y)
	Shape.initialize(self, x, y)
	self.radius = radius
	self._c = Vector2(0, 0)  -- Reused object
end

function CircleShape:draw(position, mode)
	local half_radius = self.radius / 2

	local m = "line"
	if mode then m = mode end

	love.graphics.circle(m, position.x + half_radius, position.y + half_radius, self.radius)
end

function CircleShape:drawAroundOrigin(mode)

	local m = "fill"
	if mode then m = mode end
	love.graphics.circle(m, 0, 0, self.radius)
end

function CircleShape:center(transform_position)

	-- Unwind frequently used vector operations
	local new_position_x = transform_position.x + self.position_offset.x
	local new_position_y = transform_position.y + self.position_offset.y

	local half_radius = self.radius / 2

	-- Reuse object
	self._c.x = new_position_x + half_radius
	self._c.y = new_position_y + half_radius
	return self._c

end

function CircleShape:__tostring()
	return "Circle: [ radius = " .. self.radius .. ", offset = " .. tostring(self.position_offset) .. "]"
end



-- [[ Points ]] 

PointShape = class('PointShape', Shape)

function PointShape:initialize(x, y)
	Shape.initialize(self, x, y)
end

function PointShape:draw(position)
	love.graphics.point(position.x, position.y)
end

function PointShape:drawAroundOrigin()
	love.graphics.point(0, 0)
end

function PointShape:center(transform_position)

	return transform_position + self.position_offset

end

-- [[ Rectangles ]]

RectangleShape = class('RectangleShape', Shape)

function RectangleShape:initialize(width, height, x, y)
	Shape.initialize(self, x, y)
	self.width = width
	self.height = height
	self._c = Vector2(0, 0) -- Reused object

end

function RectangleShape:draw(position, mode)

	local m = "line"
	if mode then m = mode end

	love.graphics.rectangle(m, position.x, position.y, self.width, self.height)
end

function RectangleShape:drawAroundOrigin(mode)
	
	local m = "fill"
	if mode then m = mode end

	love.graphics.rectangle(m, -self.width/2, -self.height/2, self.width, self.height)
end


function RectangleShape:center(transform_position)

	local upper_left_x = transform_position.x + self.position_offset.x
	local upper_left_y = transform_position.y + self.position_offset.y
	
	self._c.x = upper_left_x + self.width/2
	self._c.y = upper_left_y + self.height/2
	return self._c

end


function RectangleShape:__tostring()
	return "Rectangle: [ width = " .. self.width .. 
				", height = " .. self.height ..
				", offset = " .. tostring(self.position_offset) .. "]"
end