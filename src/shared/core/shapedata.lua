require 'core.vector'
require 'external.middleclass'

Shape = class('Shape')

function Shape:initialize(x, y)
	
	-- Shapes are used as hitboxes or for rendering.
	-- Position offset is how far to offset from the entity's Transform.

	self.position_offset = Vector(x or 0, y or 0)

end

-- [[ Circles ]]

CircleShape = class('CircleShape', ShapeData)

function CircleShape:initialize(radius, x, y)
	Shape.initialize(x, y)
	self.radius = radius
end

-- [[ Points ]] 

PointShape = class('PointShape', ShapeData)

function PointShape:initialize(x, y)
	Shape.initialize(x, y)
end


-- [[ Rectangles ]]

RectangleShape = class('RectangleShape', ShapeData)

function RectangleShape:initialize(width, height, x, y)
	Shape.initialize(x, y)
	self.width = width
	self.height = height

end

