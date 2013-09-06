require 'class.middleclass'
require 'engine.sprite'
require 'engine.rigidbody'
require 'engine.vector'

Tile = class('Tile', Sprite)


function Tile:initialize(name, x, y, width, height)

	Sprite.initialize(self, name, x, y, width, height)

	self.active = false
	self.visible = true

	self:setFill(220,220,204)

end
