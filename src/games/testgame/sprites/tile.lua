require 'external.middleclass'
require 'engine.sprite'
require 'engine.rigidbody'
require 'engine.vector'
require 'engine.shapes'

Tile = class('Tile', Sprite)


function Tile:initialize(name, x, y, width, height)


	sprite_and_collider_shape = RectangleShape(x, y, width, height)

	Sprite.initialize(self, name, sprite_and_collider_shape, sprite_and_collider_shape)

	self.active = true
	self.visible = true

	self:setFill(220,220,204)

end
