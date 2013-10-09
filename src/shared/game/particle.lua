require 'external.middleclass'
require 'util.poolsource'

Particle = class('Particle', PoolSource)

-- Passed some update function that
function Particle:initialize(world, type)
	self.world = world
	self.type = type
end

function Particle:getParticle()
	return { type = self.type, active = true}
end

function Particle:update(particle, dt)
	
end

function Particle:draw(particle)
	
end

-- A function which returns us an object to the pool.
function PoolSource:create()

end

-- A function called on the object when we send it to the recycler. Should do things like
-- disable any updating components.
function Particle:recycle(recycled_item)

end

-- A function called on the object when we get it back from the recycler. Could re-initialize
-- components, zero out values we want to reset, etc.
function Particle:reset(reset_item)

end