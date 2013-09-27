require 'core.components.transform'
require 'core.components.rendering'
require 'core.components.collider'
require 'core.components.motion'
require 'core.components.behavior'
require 'core.components.inputresponse'
require 'core.components.soundcomponent'
require 'core.components.emitter'
require 'core.components.messaging'
require 'core.systems.messagesystem'
require 'enums.events'
require 'enums.tags'
require 'enums.palette'
require 'behaviors.genericbehaviors'

require 'core.entity.entitybuilder'

require 'external.middleclass'

ConfettiBuilder  = class('ConfettiBuilder', EntityBuilder)

function ConfettiBuilder:initialize(world)
    EntityBuilder.initialize(self, world, 'confetti')
    return self
end

function ConfettiBuilder:create()

    EntityBuilder.create(self)
    local emitter_component = Emitter()

    emitter_component:setNumberOfEmissions(20)


    local recycleWhenOffWorld = function(entity)
    
        local transform = entity:getComponent(Transform)

        if transform.position.x < 0 or transform.position.x > love.graphics.getWidth() 
            or transform.position.y < 0 or transform.position.y > love.graphics.getHeight() then

            emitter_component:recycle(entity)
        
        end

    end 

    local emissionFunction = function(x, y, vx, vy)

        local new_entity =  self.world:getEntityManager():createEntity()
        new_entity:addComponent(Transform(x, y):setLayerOrder(-1))
        new_entity:addComponent(ShapeRendering():setColor(255, 255, 255):setShape(RectangleShape:new(3, 3)))
        new_entity:addComponent(Motion:new():setVelocity(vx, vy):setAcceleration(0, 500))
        new_entity:addComponent(Behavior():addUpdateFunction(recycleWhenOffWorld))
        return new_entity
    end

    emitter_component:setEmissionFunction(emissionFunction)

    local resetFunction = function(reset_entity, x, y, vx, vy)

        reset_entity:getComponent(Transform):moveTo(x, y)
        reset_entity:getComponent(Motion):setVelocity(vx, vy)
        reset_entity:getComponent(Motion):setAcceleration(0, 500)
        reset_entity:getComponent(ShapeRendering):enable()

    end

    emitter_component:setResetFunction(resetFunction)

    local recycleFunction = function(recycled_entity)

        recycled_entity:getComponent(Transform):moveTo(0, 0)
        recycled_entity:getComponent(ShapeRendering):disable()
        recycled_entity:getComponent(Motion):stop()

    end

    emitter_component:setRecycleFunction(recycleFunction)

    self.entity:addComponent(emitter_component)
    self.entity:tag(Tags.CONFETTI_MAKER)


end 

