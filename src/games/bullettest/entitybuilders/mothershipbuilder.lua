
require 'external.middleclass'
require 'core.entity.entitybuilder'

require 'enums.palette'
require 'enums.tags'


require 'entitybuilders.emissionport'


MotherShipBuilder  = class('MotherShipBuilder', EntityBuilder)

function MotherShipBuilder:initialize(world)
    EntityBuilder.initialize(self, world, 'mothership')
    return self
end

function MotherShipBuilder:create()

	EntityBuilder.create(self)

    self.entity:addComponent(Transform(397, 297):setLayerOrder(10))
    self.entity:addComponent(ShapeRendering():setColor(Palette.COLOR_SHIP:unpack()):setShape(CircleShape:new(15)))
    self.entity:tag(Tags.MOTHERSHIP)
   
    local emitter_component = Emitter(BulletSource(self.world))
    emitter_component:setNumberOfEmissions(100)

	local recycleEmissionWhenOffWorld = function(self)
    
        local emitter_component = self:getComponent(Emitter)

        for entity in emitter_component.object_pool.used_objects:members() do

            local transform = entity:getComponent(Transform)

            if transform.position.x < 0 or transform.position.x > love.graphics.getWidth() 
                or transform.position.y < 0 or transform.position.y > love.graphics.getHeight() then

                emitter_component:recycle(entity)
            
            end
        end
    end 

    self.entity:addComponent(Behavior():addUpdateFunction(recycleEmissionWhenOffWorld))
    self.entity:addComponent(emitter_component)

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

function mothershipInputResponse(ship, held_actions, pressed_actions, dt)

    if held_actions[Actions.FIRE] then
    
    	local emitter_component = ship:getComponent(Emitter)
    	local transform = ship:getComponent(Transform)    
		local shape = ship:getComponent(ShapeRendering):getShape()
    	local center = shape:center(transform:getPosition())

    	emitFromPortThenRotate(gun_port1, center, emitter_component, 0.1)
    	emitFromPortThenRotate(gun_port2, center, emitter_component, 0.1)
    	emitFromPortThenRotate(gun_port3, center, emitter_component, 0.1)
    	emitFromPortThenRotate(gun_port4, center, emitter_component, 0.1)

    end

end

local _vector = Vector(0, 0)

function emitFromPortThenRotate(port, position, emitter, port_rot)
	local theta = port:getRotation()
    port:setRotation(theta + port_rot)

    -- Vector rotation
    _vector.x = 150
    _vector.y = 150

    _vector:rotate(theta)

    local e = emitter:emit(position.x, position.y, _vector.x, _vector.y)
end





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

