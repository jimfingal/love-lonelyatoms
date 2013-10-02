
require 'external.middleclass'
require 'core.entity.entitybuilder'

require 'enums.palette'
require 'enums.tags'
require 'enums.actions'


require 'entitybuilders.emissionport'
require 'bulletparticle'

MotherShipBuilder  = class('MotherShipBuilder', EntityBuilder)

function MotherShipBuilder:initialize(world)
    EntityBuilder.initialize(self, world, 'mothership')
    return self
end

function MotherShipBuilder:create()

	EntityBuilder.create(self)

    self.entity:addComponent(Transform(397, 297):setLayerOrder(10))
    self.entity:addComponent(ShapeRendering():setColor(Palette.COLOR_SHIP:unpack()):setShape(CircleShape:new(15)))
    self.entity:addComponent(Motion():setDrag(50, 50))

    self.entity:tag(Tags.MOTHERSHIP)
   
    local particle_system = self.world:getSystem(ParticleSystem)
    particle_system:addParticleType(BulletParticle(world), 1000)

	local recycleEmissionWhenOffWorld = function(self)
    
        local particle_system = self.world:getSystem(ParticleSystem)
        local pool = particle_system:getParticlePool(BulletParticle)

        for particle in pool.used_objects:members() do

            if particle.x < 0 or particle.x > love.graphics.getWidth() 
                or particle.y < 0 or particle.y > love.graphics.getHeight() then

                pool:recycle(particle)
            
            end
        end
    end 

    self.entity:addComponent(Behavior():addUpdateFunction(recycleEmissionWhenOffWorld))
    
    self.entity:addComponent(InputResponse():addResponse(mothershipInputResponse))


end


 local gun_port1 = EmissionPort()
 gun_port1:setRotation(0)

 local gun_port2 = EmissionPort()
 gun_port2:setRotation(math.pi)

 local gun_port3 = EmissionPort()
 gun_port3:setRotation(math.pi / 2)

 local gun_port4 = EmissionPort()
 gun_port4:setRotation(math.pi + math.pi / 2)

 local gun_port5 = EmissionPort()
 gun_port5:setRotation(0)

 local gun_port6 = EmissionPort()
 gun_port6:setRotation(math.pi)

 local gun_port7 = EmissionPort()
 gun_port7:setRotation(math.pi / 2)

 local gun_port8 = EmissionPort()
 gun_port8:setRotation(math.pi + math.pi / 2)

function mothershipInputResponse(ship, held_actions, pressed_actions, dt)

    if held_actions[Actions.FIRE] then
    
    	local transform = ship:getComponent(Transform)    
		local shape = ship:getComponent(ShapeRendering):getShape()
    	local center = shape:center(transform:getPosition())

    	emitFromPortThenRotate(ship:getWorld(), gun_port1, center, 0.1)
    	emitFromPortThenRotate(ship:getWorld(), gun_port2, center, 0.1)
    	emitFromPortThenRotate(ship:getWorld(), gun_port3, center, 0.1)
    	emitFromPortThenRotate(ship:getWorld(), gun_port4, center, 0.1)

        emitFromPortThenRotate(ship:getWorld(), gun_port5, center, -0.1)
        emitFromPortThenRotate(ship:getWorld(), gun_port6, center, -0.1)
        emitFromPortThenRotate(ship:getWorld(), gun_port7, center, -0.1)
        emitFromPortThenRotate(ship:getWorld(), gun_port8, center, -0.1)

    end


    local ship_movement = ship:getComponent(Motion)

    local base_speed = 200
    local acceleration = 200

    if held_actions[Actions.RIGHT] then
        ship_movement.velocity.x = base_speed
    elseif held_actions[Actions.LEFT] then
        ship_movement.velocity.x = -base_speed
        -- player_movement.velocity.x = player_movement.velocity.x - (speed_delta.x * dt)
    end

    if held_actions[Actions.UP] then
        ship_movement.velocity.y = -base_speed
    elseif held_actions[Actions.DOWN] then
        ship_movement.velocity.y = base_speed    
    end
end

local _vector = Vector(0, 0)

function emitFromPortThenRotate(world, port, position, port_rot)
	local theta = port:getRotation()
    port:setRotation(theta + port_rot)

    -- Vector rotation
    _vector.x = 150
    _vector.y = 150

    _vector:rotate(theta)

    local particle_system = world:getSystem(ParticleSystem)
    local p = particle_system:getParticle(BulletParticle, position.x, position.y, _vector.x, _vector.y)

end



--[[

BulletSource = class('BulletSource', PoolSource)

function BulletSource:initialize(world)
    self.world = world    
end

function BulletSource:create(x, y, vx, vy)
    local new_entity =  self.world:getEntityManager():createEntity()
    new_entity:addComponent(Transform(x, y):setLayerOrder(-1))
    new_entity:addComponent(ShapeRendering():setColor(255, 255, 255):setShape(CircleShape:new(3)))
    new_entity:addComponent(Motion:new():setVelocity(vx, vy))
    return new_entity
end

function BulletSource:recycle(recycled_entity)
    recycled_entity:getComponent(Transform):moveTo(0, 0)
    recycled_entity:getComponent(ShapeRendering):disable()
    recycled_entity:getComponent(Motion):deactivate()
end

function BulletSource:reset(reset_entity, x, y, vx, vy)
    reset_entity:getComponent(Transform):moveTo(x, y)
    reset_entity:getComponent(Motion):activate():setVelocity(vx, vy)
    reset_entity:getComponent(ShapeRendering):enable()
end
]]
