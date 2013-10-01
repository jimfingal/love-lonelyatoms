
require 'external.middleclass'
require 'core.entity.entitybuilder'

require 'enums.palette'
require 'enums.tags'


MotherShipBuilder  = class('MotherShipBuilder', EntityBuilder)

function MotherShipBuilder:initialize(world)
    EntityBuilder.initialize(self, world, 'mothership')
    return self
end

function MotherShipBuilder:create()

	EntityBuilder.create(self)

    self.entity:addComponent(Transform(375, 275):setLayerOrder(10))
    self.entity:addComponent(ShapeRendering():setColor(Palette.COLOR_SHIP:unpack()):setShape(RectangleShape:new(50, 50)))
    self.entity:tag(Tags.MOTHERSHIP)
   
    local emitter_component = Emitter(BulletSource(self.world))
    emitter_component:setNumberOfEmissions(5)


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

function mothershipInputResponse(ship, held_actions, pressed_actions, dt)

    if pressed_actions[Actions.FIRE] then
    
    	local emitter_component = ship:getComponent(Emitter)
    	local transform = ship:getComponent(Transform)    
        local e = emitter_component:emit(transform:getPosition().x, transform:getPosition().y, math.randomPlusOrMinus() * 200 * math.random(), -200 * math.random())

    end

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
    recycled_entity:getComponent(Motion):stop()
end

function BulletSource:reset(reset_entity, x, y, vx, vy)
    reset_entity:getComponent(Transform):moveTo(x, y)
    reset_entity:getComponent(Motion):setVelocity(vx, vy)
    reset_entity:getComponent(ShapeRendering):enable()
end

