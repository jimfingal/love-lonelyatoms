require 'external.middleclass'
require 'game.particle'

Stars = class('Stars', Particle)

-- Passed some update function that
function Stars:initialize(world)
	self.world = world
	self.type = "star"
end

function Stars:update(particle, dt)
	particle.x = particle.x + particle.vx * dt
	particle.y = particle.y + particle.vy * dt
end

function Stars:draw(particle)
	love.graphics.setColor(particle.r, particle.g, particle.b, 255)
	love.graphics.circle('fill', particle.x + particle.radius/2, particle.y  + particle.radius/2, particle.radius)
end

-- A function which returns us an object to the pool.
function Stars:create(x, y, vx, vy)
	return { type = self.type, active=true, x = x, y = y, vx = vx, vy = vy, radius = math.random(3), r = math.random(255), g =  math.random(255), b =  math.random(255), a =  math.random(255)}
end

-- A function called on the object when we send it to the recycler. Should do things like
-- disable any updating components.
function Stars:recycle(recycled_item)
	recycled_item.active = false
end

-- A function called on the object when we get it back from the recycler. Could re-initialize
-- components, zero out values we want to reset, etc.
function Stars:reset(reset_item, x, y, vx, vy)
	reset_item.active = true
	reset_item.x = x
	reset_item.y = y
	reset_item.vx = vx
	reset_item.vy = vy
end