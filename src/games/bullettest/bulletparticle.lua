require 'external.middleclass'
require 'particle.particle'

BulletParticle = class('BulletParticle', Particle)

-- Passed some update function that
function BulletParticle:initialize(world)
	self.world = world
	self.type = "bullet"
end

function BulletParticle:update(particle, dt)
	particle.x = particle.x + particle.vx * dt
	particle.y = particle.y + particle.vy * dt
	particle.r = particle.r - 1
	particle.g = particle.g - 1
	particle.b = particle.b - 1

end

function BulletParticle:draw(particle)
	love.graphics.setColor(particle.r, particle.g, particle.b, 255)
	love.graphics.circle('fill', particle.x + particle.radius/2, particle.y  + particle.radius/2, particle.radius)
end

-- A function which returns us an object to the pool.
function BulletParticle:create(x, y, vx, vy)
	return { type = self.type, active=true, x = x, y = y, vx = vx, vy = vy, radius = 3, r = 255, g = 255, b = 255}
end

-- A function called on the object when we send it to the recycler. Should do things like
-- disable any updating components.
function BulletParticle:recycle(recycled_item)
	recycled_item.active = false
end

-- A function called on the object when we get it back from the recycler. Could re-initialize
-- components, zero out values we want to reset, etc.
function BulletParticle:reset(reset_item, x, y, vx, vy)
	reset_item.active = true
	reset_item.x = x
	reset_item.y = y
	reset_item.vx = vx
	reset_item.vy = vy
	reset_item.r = 255
	reset_item.g = 255
	reset_item.b = 255

end