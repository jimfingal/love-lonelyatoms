require 'core.vector'
require 'external.middleclass'

Shape = class('Shape')

function Shape:initialize()
	self:movableInit()
end

-- Circles

CircleShape = class('CircleShape', ShapeData)

function CircleShape:initialize(radius)
	Shape.initialize()
	self.radius = radius
end

function CircleShape:draw(position, mode)
	local half_radius = self.radius / 2
	love.graphics.circle(mode or 'line', position.x + half_radius, position.y + half_radius, self.radius)
end


-- helper to find my center given a position
function CircleShape:center(position)
	local half_radius = self.radius / 2
	local center = Vector(position.x + half_radius, position.y + half_radius)
	return center
end


-- Points

PointShape = class('PointShape', ShapeData)

function PointShape:initialize()
	Shape.initialize(x, y)
end

function PointShape:draw(position)
	love.graphics.point(position.x, position.y)
end

-- Rectangles

RectangleShape = class('RectangleShape', ShapeData)

-- X and Y are point in upper left hand corner
function RectangleShape:initialize(width, height)

	self.width = width
	self.height = height

end

function RectangleShape:draw(position, mode)
	love.graphics.rectangle(mode or "line", position.x, position.y, self.width, self.height)
end
