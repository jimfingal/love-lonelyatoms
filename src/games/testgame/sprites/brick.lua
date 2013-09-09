require 'external.middleclass'
require 'engine.sprite'
require 'engine.rigidbody'
require 'engine.vector'
require 'engine.shapes'

Brick = class('Brick', Sprite)


function Brick:initialize(name, x, y, width, height, sound, r, g, b)


	sprite_and_collider_shape = RectangleShape(x, y, width, height)

	Sprite.initialize(self, name, sprite_and_collider_shape, sprite_and_collider_shape)

	self.active = true
	self.visible = true

	self:setFill(r, g, b)
	
	self.snd = sound

end

function Brick:playSound()

end