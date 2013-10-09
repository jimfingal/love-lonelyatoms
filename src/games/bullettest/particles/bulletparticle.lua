require 'external.middleclass'
require 'particle.particle'
require 'core.quad.aabb'

BulletParticle = class('BulletParticle', Particle)

-- Passed some update function that
function BulletParticle:initialize(world)
	self.world = world
	self.type = "bullet"
end

function BulletParticle:update(particle, dt)

	-- Quit updating if we've faded out


	particle.x = particle.x + particle.vx * dt
	particle.y = particle.y + particle.vy * dt
	particle.aabb.x = particle.x
	particle.aabb.y = particle.y

	particle.a = particle.a - 1
	--[[
	particle.r = particle.r - 1
	particle.g = particle.g - 1
	particle.b = particle.b - 1
	]]

	if particle.r <= 0 or particle.g <= 0  or particle.b <= 0 or particle.a <=0 then 
		particle.a = 0 
	end
end

function BulletParticle:draw(particle)
	love.graphics.setColor(particle.r, particle.g, particle.b, particle.a)
	love.graphics.circle('fill', particle.x + particle.radius/2, particle.y  + particle.radius/2, particle.radius)
	love.graphics.line(particle.ox, particle.oy, particle.x + particle.radius/2, particle.y  + particle.radius/2)

end

-- A function which returns us an object to the pool.
function BulletParticle:create(x, y, vx, vy)
	local rad = 3  -- math.random(3)
	return { type = self.type, active=true, x = x, y = y, ox = x, oy = y, vx = vx, vy = vy, aabb = AABB(x, y, rad * 2, rad * 2), radius = rad, r = 255, g = 255, b = 255, a = 255}
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
	reset_item.ox = x
	reset_item.oy = y
	reset_item.vx = vx
	reset_item.vy = vy
	reset_item.r = 255
	reset_item.g = 255
	reset_item.b = 255
	reset_item.a = 255

end