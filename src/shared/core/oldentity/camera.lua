-- Cribbing from:
-- http://nova-fusion.com/2011/04/19/cameras-in-love2d-part-1-the-basics/
-- https://github.com/vrld/hump/blob/master/camera.lua

require 'external.middleclass'
require 'core.mixins.movable'
require 'core.mixins.scalable'
require 'core.mixins.rotatable'


Camera = class('Camera', Entity)
Camera:include(Movable)
Camera:include(Scalable)


function Camera:initialize(x, y)

	Entity.initialize(self, x, y)
	self:movableInit()
	self:scalableInit()

end


function Camera:attach()

	love.graphics.push()

	-- Scale
	love.graphics.scale(self:unpackScale())

	-- Translate
	love.graphics.translate(-self.position.x, -self.position.y)

end

function Camera:detach()

	love.graphics.pop()
end

-- Option if you have camera watch specific things
function Camera:draw(drawable)
	self:attach()
	drawable:draw()
	self:detach()
end