require 'external.middleclass'
require 'core.sprite'
require 'core.shapes'

Tile = class('Tile', Sprite)


function Tile:initialize(x, y, width, height)

	sprite_and_collider_shape = RectangleShape(width, height)

	Sprite.initialize(self, x, y, sprite_and_collider_shape)

	self:setColor(220,220,204)

end
