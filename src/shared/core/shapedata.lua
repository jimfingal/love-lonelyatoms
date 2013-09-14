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


-- [[ Points ]] 

PointShape = class('PointShape', Shape)

function PointShape:initialize(x, y)
	Shape.initialize(self, x, y)
end

function PointShape:draw(position)
	love.graphics.point(position.x, position.y)
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