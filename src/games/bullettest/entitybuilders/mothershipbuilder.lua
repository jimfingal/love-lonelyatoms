
require 'external.middleclass'
require 'entity.entitybuilder'
require 'entity.systems.tweensystem'
require 'entity.systems.coroutinesystem'

Easing = require 'external.easing'

require 'enums.palette'
require 'enums.tags'
require 'enums.actions'

require 'behaviors.genericbehaviors'
require 'entitybuilders.emissionport'
require 'particles.bulletparticle'
require 'particles.pointparticle'

require 'entity.components.coroutinebehavior'


MotherShipBuilder  = class('MotherShipBuilder', EntityBuilder)

function MotherShipBuilder:initialize(world)
    EntityBuilder.initialize(self, world, 'mothership')
    return self
end

function MotherShipBuilder:create()

	EntityBuilder.create(self)

    self.entity:addComponent(Transform(397, 297):setLayerOrder(10))
    local rendering = Rendering()
    rendering:addRenderable(ShapeRendering():setColor(Palette.COLOR_SHIP:unpack()):setShape(CircleShape:new(15)), "body")
    rendering:addRenderable(ShapeRendering():setColor(205, 147, 147):setShape(CircleShape:new(5, 3, 3)), "eye")

    self.entity:addComponent(rendering)

    self.entity:addComponent(Motion():setDrag(50, 50):setMaxAcceleration(500, 500))

    self.entity:tag(Tags.MOTHERSHIP)
   
    local particle_system = self.world:getSystem(ParticleSystem)

    particle_system:addParticleType(PointParticle(world), 2000)

    -- particle_system:addParticleType(BulletParticle(world), 2000)

	local recycleEmissionWhenOffWorld = function(self)
    
        local particle_system = self.world:getSystem(ParticleSystem)
        -- local pool = particle_system:getParticlePool(BulletParticle)
        local pool = particle_system:getParticlePool(PointParticle)

        for particle in pool.used_objects:members() do

            if particle.x < 0 or particle.x > love.graphics.getWidth() 
                or particle.y < 0 or particle.y > love.graphics.getHeight() then

                pool:recycle(particle)
            
            end
        end
    end 

    local unit_vector = Vector2(5, 5)

    local rotateInCircle = function(self)
    
        local transform = self:getComponent(Transform)
        local rot = transform:getRotation()

        unit_vector.x = 50
        unit_vector.y = 50

        unit_vector:rotate(rot)

        transform.position.x = 400 + unit_vector.x
        transform.position.y = 300 + unit_vector.y

        transform:rotate(0.05)
    end 

    local behavior = Behavior()
    behavior:addUpdateFunction(recycleEmissionWhenOffWorld)
    --behavior:addUpdateFunction(rotateInCircle)
    behavior:addUpdateFunction(GenericBehaviors.bounceEntityOffWorldEdges)
    self.entity:addComponent(behavior)
    
    self.entity:addComponent(InputResponse():addResponse(mothershipInputResponse))

    local fade = nil
    fade = function()

        local entity = self.world:getTaggedEntity(Tags.MOTHERSHIP)
        local c = entity:getComponent(Rendering):getRenderable("eye"):getColor()
        local world = entity:getWorld()
        
        local r_fade, g_fade, b_fade = 100, 100, 100
        local easing = Easing.inCirc

        if c.r < 200 then 
            r_fade, g_fade, b_fade = 205, 147, 147
            easing = Easing.outCirc
    
        end

        local tween_system = self.world:getSystem(TweenSystem)
        local schedule_system = self.world:getSystem(ScheduleSystem)

        schedule_system:doAfter(0.5, function()
            tween_system:addTween(1, c, {r = r_fade, g = g_fade, b = b_fade }, Easing.linear, fade)
        end)
    end

    fade()


    local co_behavior = CoroutineBehavior()

    local ship = self.entity

    local moveMothership = function()

        -- [[ Move down
        move(ship, 270, 100, 2)
        sleep(1)
        --]]

        -- [[ Move left
        move(ship, 180, 100, 1)
        sleep(1)
        --]]

        -- [[ Move right
        move(ship, 0, 100, 1)
        sleep(1)
        --]]

        --[ Move up
        move(ship, 90, 100, 1)
        sleep(1)
        --]]
       
        moveTo(ship, Vector2(397, 297), 1)

    end

    -- co_behavior:addCoroutineFunction(moveMothership)

    -- self.entity:addComponent(co_behavior)


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

local _vector = Vector2(0, 0)

local emitFromPort = function(world, port, position)
    local theta = port:getRotation()
    -- Vector rotation
    _vector.x = 300
    _vector.y = 0
    _vector:rotate(theta)
    local particle_system = world:getSystem(ParticleSystem)
    -- local p = particle_system:getParticle(BulletParticle, position.x, position.y, _vector.x, _vector.y)
    local p = particle_system:getParticle(PointParticle, position.x, position.y, _vector.x, _vector.y)

end

local emitFromPortThenRotate = function(world, port, position, port_rot)
    local theta = port:getRotation()
    port:setRotation(theta + port_rot)

    -- Vector rotation
    _vector.x = 150
    _vector.y = 150

    -- _vector.x = 150 + math.random(30)
    -- _vector.y = 150 + math.random(30)

    _vector:rotate(theta)

    local particle_system = world:getSystem(ParticleSystem)

    -- local p = particle_system:getParticle(BulletParticle, position.x, position.y, _vector.x, _vector.y)
    local p = particle_system:getParticle(PointParticle, position.x, position.y, _vector.x, _vector.y)
end

function mothershipInputResponse(ship, held_actions, pressed_actions, dt)
   
    local transform = ship:getComponent(Transform)    
    local shape = ship:getComponent(Rendering):getRenderable("eye"):getShape()
    local center = shape:center(transform:getPosition())
    local world = ship:getWorld()

    if held_actions[Actions.FIRE] then
 

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

        --ship_movement.acceleration.x = acceleration

        -- emitFromPort(world, gun_port6, center)

    elseif held_actions[Actions.LEFT] then

        ship_movement.velocity.x = -base_speed

        --ship_movement.acceleration.x = -acceleration

        -- emitFromPort(world, gun_port5, center)

        -- player_movement.velocity.x = player_movement.velocity.x - (speed_delta.x * dt)
    end

    if held_actions[Actions.UP] then
    
        ship_movement.velocity.y = -base_speed

        --ship_movement.acceleration.y = -acceleration


        -- emitFromPort(world, gun_port7, center)

    elseif held_actions[Actions.DOWN] then
    
        ship_movement.velocity.y = base_speed 

        -- ship_movement.acceleration.y = acceleration
  
        -- emitFromPort(world, gun_port8, center)

    end
end

