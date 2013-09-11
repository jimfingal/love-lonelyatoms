require 'external.middleclass'
require 'engine.entity'
require 'engine.mixins.movable'
require 'engine.mixins.visible'
require 'engine.mixins.collidable'

Sprite = class('Sprite', Entity)

Sprite:include(Movable)
Sprite:include(Visible)
Sprite:include(Collidable)

function Sprite:initialize(x, y, shape)

	Entity.initialize(self)
	
	self:movableInit(x, y)
	self:visibleInit(shape)
	self:collidableInit(shape)

end


function Sprite:processInput(dt, input)
	-- Overrided by subclasses
end

function Sprite:update(dt)
	-- Overrided by subclasses
end

function Sprite:endFrame(dt)
	-- Overrided by subclasses
end
