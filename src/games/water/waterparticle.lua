require 'external.middleclass'
require 'game.particle'
require 'math.quad.aabb'

WaterParticle = class('WaterParticle', Particle)

-- Spring constant for forces applied by adjacent points
WaterParticle.SPRING_CONSTANT =0.005
-- Sprint constant for force applied to baseline
WaterParticle.SPRING_CONSTANT_BASELINE = 0.005
-- Damping to apply to speed changes
WaterParticle.DAMPING = 0.95
-- Damping to apply to speed changes
WaterParticle.SPREAD = 2.0


-- Passed some update function that
function WaterParticle:initialize(world)
	self.world = world
	self.type = "water"
end

function WaterParticle.updateParticles(particle_linked_list, dt)

	for i = 0, 1 do 
		for _, node in particle_linked_list:members() do

			local force = 0
			local forceFromLeft, forceFromRight, forceToBaseline = 0, 0, 0

			local particle = node:getValue()

			if node:getLeftLink() then 
				local left_particle = node:getLeftLink():getValue()
		        local ldy = left_particle.y - particle.y
		        forceFromLeft = WaterParticle.SPRING_CONSTANT * ldy * WaterParticle.SPREAD
	 		end

	 		if node:getRightLink() then 
	 			local right_particle = node:getRightLink():getValue()
		        local rdy = right_particle.y - particle.y
	    	    forceFromRight =  WaterParticle.SPRING_CONSTANT * rdy * WaterParticle.SPREAD
	    	end

	        local dy = particle.target_height - particle.y
	        forceToBaseline = WaterParticle.SPRING_CONSTANT_BASELINE * dy


	        -- Sum up forces
	       	force = force + forceFromLeft
	        force = force + forceFromRight
	        force = force + forceToBaseline

	        -- Calculate acceleration
	        local acceleration = force / particle.mass


	 		-- Apply acceleration (with damping)
	        particle.vy =  WaterParticle.DAMPING * particle.vy + acceleration

	        -- Apply speed

	        particle.y = particle.y + particle.vy

		end
	end

end


function WaterParticle:draw(particle)
	love.graphics.setColor(particle.r, particle.g, particle.b, 255)
	love.graphics.circle('fill', particle.x + particle.radius/2, particle.y  + particle.radius/2, particle.radius)
	love.graphics.rectangle('fill', particle.x, particle.y + particle.radius/2, particle.radius * 2, love.graphics.getHeight())

end

-- A function which returns us an object to the pool.
function WaterParticle:create(x, y, vx, vy, left)
	return { type = self.type, 
				active=true, 
				target_height = y,
				x = x, 
				y = y, 
				vx = vx, 
				vy = vy, 
				radius = 6, 
				r = 68, 
				g = 139, 
				b = 225,
				mass = 1,
				left = left}
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