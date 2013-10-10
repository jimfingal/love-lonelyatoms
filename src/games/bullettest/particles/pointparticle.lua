require 'external.middleclass'
require 'game.particle'
require 'math.quad.aabb'

PointParticle = class('PointParticle', Particle)

-- Passed some update function that
function PointParticle:initialize(world)
	self.world = world
	self.type = "bullet"
end

function PointParticle:update(particle, dt)

	-- Quit updating if we've faded out
	
	particle.x = particle.x + particle.vx * dt
	particle.y = particle.y + particle.vy * dt
	particle.aabb.x = particle.x
	particle.aabb.y = particle.y

	--particle.a = particle.a - 1
	particle.length = particle.length - (dt * 25)
	--[[
	particle.r = particle.r - 1
	particle.g = particle.g - 1
	particle.b = particle.b - 1
	]]

	if particle.r <= 0 or particle.g <= 0  or particle.b <= 0 or particle.a <=0 then 
		particle.a = 0 
	end

	if particle.length <= 0 then
		particle.length = 0
	end
end

function PointParticle:draw(particle)
	love.graphics.setColor(particle.r, particle.g, particle.b, particle.a)

	local len_v = math.sqrt(particle.vx * particle.vx + particle.vy * particle.vy)
	local norm_x = particle.vx / len_v
	local norm_y = particle.vy / len_v

	love.graphics.line(particle.x, particle.y, particle.x + (norm_x * particle.length), particle.y + (norm_y * particle.length))

end

-- A function which returns us an object to the pool.
function PointParticle:create(x, y, vx, vy)
	return { type = self.type, active=true, x = x, y = y, ox = x, oy = y, vx = vx, vy = vy, aabb = AABB(x, y, 1, 1), length=20.0, r = 255, g = 255, b = 255, a = 255}
end

-- A function called on the object when we send it to the recycler. Should do things like
-- disable any updating components.
function PointParticle:recycle(recycled_item)
	recycled_item.active = false
end

-- A function called on the object when we get it back from the recycler. Could re-initialize
-- components, zero out values we want to reset, etc.
function PointParticle:reset(reset_item, x, y, vx, vy)
	reset_item.active = true
	reset_item.x = x
	reset_item.y = y
	reset_item.ox = ox
	reset_item.oy = oy
	reset_item.vx = vx
	reset_item.vy = vy
	reset_item.r = 255
	reset_item.g = 255
	reset_item.b = 255
	reset_item.a = 255
	reset_item.length = 20.0

end