require 'external.middleclass'
require 'entity.system'
require 'entity.components.emitter'
require 'collections.set'

ParticleSystem = class('ParticleSystem', System)

function ParticleSystem:initialize(world)

	System.initialize(self, 'Particle System')
	self.world = world
	self.particles = {}
	self.particle_sources = {}
end

function ParticleSystem:addParticleType(particle_source, size)

	--assert(false, tostring(particle_source))
	self.particles[particle_source.class] = Pool(particle_source, size)
	self.particle_sources[particle_source.class] = particle_source
end

function ParticleSystem:getParticle(particle_class, ...)
	local pool = self.particles[particle_class]
	return pool:getObject(...)
end

function ParticleSystem:getParticlePool(particle_class)
	return self.particles[particle_class]
end

function ParticleSystem:updateParticles(dt)

	for particle_class, pool in pairs(self.particles) do

		local particle_source = self.particle_sources[particle_class]

		for particle in pool.used_objects:members() do
			if particle.active then particle_source:update(particle, dt) end
		end	

	end

end

function ParticleSystem:drawParticles()

	for particle_class, pool in pairs(self.particles) do
		
		local particle_source = self.particle_sources[particle_class]
		
		for particle in pool.used_objects:members() do
			if particle.active then particle_source:draw(particle) end
		end	
	end

end

function ParticleSystem:__tostring()

	local s = "ParticleSystem: ["

	for particle_class, pool in pairs(self.particles) do
		s = s .. "( " .. tostring(particle_class) .. "; " .. tostring(pool) .. 
				"; source = " .. tostring(self.particle_sources[particle_class]) .. ")"
	end

	s = s .. "] "

	return s

end