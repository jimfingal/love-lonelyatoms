require 'external.middleclass'
require 'particle.particle'
require 'core.quad.aabb'

WaterParticle = class('WaterParticle', Particle)

-- Passed some update function that
function WaterParticle:initialize(world)
	self.world = world
	self.type = "water"
end

function WaterParticle:update(particle, dt)

	local x = particle.y - particle.target_height
    local ay = (-particle.k * x) - (particle.dampening * particle.vy)

	particle.x = particle.x + particle.vx * dt
    particle.y = particle.y + particle.vy * dt

    particle.vy = particle.vy + ay


end

function WaterParticle:draw(particle)
	love.graphics.setColor(particle.r, particle.g, particle.b, 255)
	love.graphics.circle('fill', particle.x + particle.radius/2, particle.y  + particle.radius/2, particle.radius)
end

-- A function which returns us an object to the pool.
function WaterParticle:create(x, y, vx, vy)
	return { type = self.type, 
				active=true, 
				k = 0.05,
				dampening = 0.005,
				target_height = y,
				x = x, 
				y = y, 
				vx = vx, 
				vy = vy, 
				radius = 5, 
				r = 68, 
				g = 139, 
				b = 225}
end

-- A function called on the object when we send it to the recycler. Should do things like
-- disable any updating components.
function WaterParticle:recycle(recycled_item)
	recycled_item.active = false
end

-- A function called on the object when we get it back from the recycler. Could re-initialize
-- components, zero out values we want to reset, etc.
function WaterParticle:reset(reset_item, x, y, vx, vy)
	reset_item.active = true
	reset_item.x = x
	reset_item.y = y
	reset_item.vx = vx
	reset_item.vy = vy
end