
require 'external.middleclass'
require 'entity.entitybuilder'
require 'entity.systems.tweensystem'
Easing = require 'external.easing'

require 'enums.palette'
require 'enums.tags'
require 'enums.actions'

require 'behaviors.genericbehaviors'
require 'entitybuilders.emissionport'
require 'particles.stars'

StarBuilder  = class('StarBuilder', EntityBuilder)

function StarBuilder:initialize(world)
    EntityBuilder.initialize(self, world, 'stars')
    return self
end

function StarBuilder:create()

	EntityBuilder.create(self)

    local particle_system = self.world:getSystem(ParticleSystem)
    particle_system:addParticleType(Stars(world), 100)

	local recycleEmissionWhenOffWorld = function(self)
    
        local particle_system = self.world:getSystem(ParticleSystem)
        local pool = particle_system:getParticlePool(Stars)

        for particle in pool.used_objects:members() do

            if particle.x < 0 or particle.x > love.graphics.getWidth() 
                or particle.y < 0 or particle.y > love.graphics.getHeight() then

                pool:recycle(particle)
            
            end
        end
    end 


    local generateStars = function(self)
        local r = math.random(10)

        if r == 10 then
            local particle_system = self:getWorld():getSystem(ParticleSystem)
            local p = particle_system:getParticle(Stars, math.random(love.graphics.getWidth()), 0, 0, math.random(100, 300))
        end
    end
    
    local behavior = Behavior()
    behavior:addUpdateFunction(recycleEmissionWhenOffWorld)
    behavior:addUpdateFunction(generateStars)

    self.entity:addComponent(behavior)

end
