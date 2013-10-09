require 'external.middleclass'
require 'core.oldentity.shapes'

Tile = class('Tile', CollidableRectangle)


function Tile:initialize(x, y, width, height)

	CollidableRectangle.initialize(self, x, y, width, height)

	self:setColor(220,220,204)

end
