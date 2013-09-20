-- Cribbing from:
-- http://nova-fusion.com/2011/04/19/cameras-in-love2d-part-1-the-basics/
-- https://github.com/vrld/hump/blob/master/camera.lua

require 'external.middleclass'
require 'core.entity.system'
require 'utils.mathutils'


CameraSystem = class('CameraSystem', System)

function CameraSystem:initialize()

	self.transform = Transform(0, 0)
	self.motion = Motion()


end


function CameraSystem:attach()

	love.graphics.push()

	-- Scale
	love.graphics.scale(self.transform:unpackScale())

	-- Translate
	love.graphics.translate(-self.transform:getPosition().x * self.transform.scale.x, -self.transform:getPosition().y * self.transform.scale.y)

end

function CameraSystem:detach()
	love.graphics.pop()
end

-- Option if you have camera watch specific things
function CameraSystem:draw(drawable)
	self:attach()
	drawable:draw()
	self:detach()
end