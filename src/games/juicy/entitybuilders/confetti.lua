require 'entity.components.transform'
require 'entity.components.rendering'
require 'entity.components.collider'
require 'entity.components.motion'
require 'entity.components.behavior'
require 'entity.components.inputresponse'
require 'entity.components.soundcomponent'
require 'entity.components.emitter'
require 'entity.components.messaging'
require 'entity.systems.messagesystem'
require 'enums.events'
require 'enums.tags'
require 'enums.palette'
require 'game.generic.genericbehaviors'
require 'util.poolsource'

require 'entity.entitybuilder'

require 'external.middleclass'


Confetti = class('Confetti', PoolSource)

function Confetti:initialize(world)
    self.world = world    
end

function Confetti:create(x, y, vx, vy)
    local new_entity =  self.world:getEntityManager():createEntity()
    new_entity:addComponent(Transform(x, y):setLayerOrder(-1))
    new_entity:addComponent(Rendering():addRenderable(ShapeRendering():setColor(255, 255, 255):setShape(RectangleShape:new(3, 3))))
    new_entity:addComponent(Motion:new():setVelocity(vx, vy):setAcceleration(0, 500))
    return new_entity
end

function Confetti:recycle(recycled_entity)
    recycled_entity:getComponent(Transform):moveTo(0, 0)
    recycled_entity:getComponent(Rendering):disable()
    recycled_entity:getComponent(Motion):stop()
end

function Confetti:reset(reset_entity, x, y, vx, vy)
    reset_entity:getComponent(Transform):moveTo(x, y)
    reset_entity:getComponent(Motion):setVelocity(vx, vy)
    reset_entity:getComponent(Motion):setAcceleration(0, 500)
    reset_entity:getComponent(Rendering):enable()
end


ConfettiBuilder  = class('ConfettiBuilder', EntityBuilder)

function ConfettiBuilder:initialize(world)
    EntityBuilder.initialize(self, world, 'confetti')
    return self
end



function ConfettiBuilder:create()

    EntityBuilder.create(self)

    local emitter_component = Emitter(Confetti(self.world))
    emitter_component:setNumberOfEmissions(20)
    
    local recycleConfettiWhenOffWorld = function(self)
    
        local emitter_component = self:getComponent(Emitter)

        for entity in emitter_component.object_pool.used_objects:members() do

            local transform = entity:getComponent(Transform)

            if transform.position.x < 0 or transform.position.x > love.graphics.getWidth() 
                or transform.position.y < 0 or transform.position.y > love.graphics.getHeight() then

                emitter_component:recycle(entity)
            
            end
        end
    end 

    self.entity:addComponent(emitter_component)

    self.entity:addComponent(Behavior():addUpdateFunction(recycleConfettiWhenOffWorld))



 
    self.entity:tag(Tags.CONFETTI_MAKER)


end 

