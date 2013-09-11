require 'external.middleclass'
require 'core.entity'
require 'core.mixins.movable'
require 'core.mixins.visible'
require 'core.mixins.collidable'

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
