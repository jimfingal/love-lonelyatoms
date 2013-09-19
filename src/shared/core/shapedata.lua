require 'core.vector'
require 'external.middleclass'

Shape = class('Shape')

function Shape:initialize(x, y)
	
	-- Shapes are used as hitboxes or for rendering.
	-- Position offset is how far to offset from the entity's Transform.

	self.position_offset = Vector(x or 0, y or 0)

end

function Shape:offset()
	return self.position_offset
end

-- [[ Circles ]]

CircleShape = class('CircleShape', Shape)

function CircleShape:initialize(radius, x, y)
	Shape.initialize(self, x, y)
	self.radius = radius
end

function CircleShape:draw(position, mode)
	local half_radius = self.radius / 2
	love.graphics.circle(mode or 'line', position.x + half_radius, position.y + half_radius, self.radius)
end

function CircleShape:drawAroundOrigin(mode)
	love.graphics.circle(mode or 'line', 0, 0, self.radius)
end

function CircleShape:center(transform_position)

	local new_position = transform_position + self.position_offset
	local half_radius = self.radius / 2
	return Vector(new_position.x + half_radius, new_position.y + half_radius)

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

end

function RectangleShape:draw(position, mode)
	love.graphics.rectangle(mode or "line", position.x, position.y, self.width, self.height)
end

function RectangleShape:drawAroundOrigin(mode)
	love.graphics.rectangle(mode or "line", -self.width/2, -self.height/2, self.width, self.height)
end


function RectangleShape:center(transform_position)

	local upper_left = transform_position + self.position_offset
	return Vector(upper_left.x + self.width/2, upper_left.y + self.height/2)

end


function RectangleShape:__tostring()
	return "Rectangle: [ width = " .. self.width .. 
				", height = " .. self.height ..
				", offset = " .. tostring(self.position_offset) .. "]"
end