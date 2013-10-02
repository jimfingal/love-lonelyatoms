
require 'external.middleclass'
require 'core.entity.entitybuilder'

require 'enums.palette'
require 'enums.tags'
require 'enums.actions'


require 'entitybuilders.emissionport'
require 'playerbulletparticle'

require 'socket'

OpponentBuilder  = class('OpponentBuilder', EntityBuilder)

function OpponentBuilder:initialize(world)
    EntityBuilder.initialize(self, world, 'opponent')
    return self
end

function OpponentBuilder:create()

	EntityBuilder.create(self)

    self.entity:addComponent(Transform(397, 500):setLayerOrder(10))
    self.entity:addComponent(ShapeRendering():setColor(Palette.COLOR_OPPONENT:unpack()):setShape(RectangleShape:new(10, 10)))
    self.entity:addComponent(Motion():setDrag(50, 50):setMaxAcceleration(500, 500))

    self.entity:tag(Tags.MOTHERSHIP)
   
    local particle_system = self.world:getSystem(ParticleSystem)
    particle_system:addParticleType(PlayerBulletParticle(world), 100)

	local recycleEmissionWhenOffWorld = function(self)
    
        local particle_system = self.world:getSystem(ParticleSystem)
        local pool = particle_system:getParticlePool(PlayerBulletParticle)

        for particle in pool.used_objects:members() do

            if particle.x < 0 or particle.x > love.graphics.getWidth() 
                or particle.y < 0 or particle.y > love.graphics.getHeight() then

                pool:recycle(particle)
            
            end
        end
    end 


    local gun_port1 = EmissionPort()
    gun_port1:setRotation(0)


    local _vector = Vector(0, 0)

    local emitFromPort = function(world, port, position)
        local theta = port:getRotation()
        -- Vector rotation
        _vector.x = 0
        _vector.y = -100
        _vector:rotate(theta)
        local particle_system = world:getSystem(ParticleSystem)
        local p = particle_system:getParticle(PlayerBulletParticle, position.x, position.y, _vector.x, _vector.y)

    end

    fire_co = coroutine.create(function(ship)

        local transform = ship:getComponent(Transform)    
        local shape = ship:getComponent(ShapeRendering):getShape()
        local center = shape:center(transform:getPosition())
        local world = ship:getWorld()
        for i = 1, math.huge do
            if i % 5 == 0 and i % 50 < 25 then
                emitFromPort(world, gun_port1, center)
            end
            coroutine.yield()
        end
    end)

    local fire_every_three = function(self)
        local state,result = coroutine.resume(fire_co, self)
         if not state then
            error( tostring(result), 2 )    -- Output error message
        end
        return state,result
    end



    local behavior = Behavior()
    behavior:addUpdateFunction(recycleEmissionWhenOffWorld)
    behavior:addUpdateFunction(fire_every_three)

    self.entity:addComponent(behavior)


end




