require 'core.vector'
require 'core.entity.entity'
require 'core.mixins.movable'
require 'core.mixins.visible'
require 'core.mixins.collidable'


require 'external.middleclass'

Shape = class('Shape', Entity)
Shape:include(Movable)
Shape:include(Visible)

function Shape:initialize(x, y)
	Entity.initialize(self, x, y)
	self:movableInit()
	self:visibleInit()
end

-- Circles

CircleShape = class('CircleShape', Shape)

function CircleShape:initialize(x, y, radius)
	Shape.initialize(self, x, y)
	self.radius = radius
end

function CircleShape:render(mode)
	local center = self:center()
	love.graphics.circle(mode or 'line', center.x, center.y, self.radius)
end


-- helper to find my center given a position
function CircleShape:center()
	local half_radius = self.radius / 2
	local center = Vector(self.position.x + half_radius, self.position.y + half_radius)
	return center
end

CollidableCircle = class('CollidableCircle', CircleShape)

CollidableCircle:include(Collidable)

function CollidableCircle:initialize(x, y, radius)
	CircleShape.initialize(self, x, y, radius)
	self:collidableInit()
end



-- Points

PointShape = class('PointShape', Shape)

function PointShape:initialize(x, y)
	Shape.initialize(self, x, y)
end

function PointShape:render()
	love.graphics.point(self.position.x, self.position.y)
end


CollidablePoint = class('CollidablePoint', PointShape)

CollidablePoint:include(Collidable)

function CollidablePoint:initialize(x, y)
	PointShape.initialize(self, x, y)
	self:collidableInit()
end


-- Rectangles

RectangleShape = class('RectangleShape', Shape)

-- X and Y are point in upper left hand corner
function RectangleShape:initialize(x, y, width, height)
	Shape.initialize(self, x, y)
	self.width = width
	self.height = height

end

function RectangleShape:render(mode)
	love.graphics.rectangle(mode or "line", self.position.x, self.position.y, self.width, self.height)
end


CollidableRectangle = class('CollidableRectangle', RectangleShape)

CollidableRectangle:include(Collidable)

function CollidableRectangle:initialize(x, y, width, height)
	RectangleShape.initialize(self, x, y, width, height)
	self:collidableInit()
end
