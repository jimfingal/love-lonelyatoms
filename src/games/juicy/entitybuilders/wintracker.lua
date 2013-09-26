
require 'external.middleclass'
require 'core.entity.entitybuilder'

WinTrackerBuilder  = class('WinTrackerBuilder', EntityBuilder)

function WinTrackerBuilder:initialize(world)
    EntityBuilder.initialize(self, world, 'win tracker')
    return self
end

function WinTrackerBuilder:create()

	EntityBuilder.create(self)

    self.entity:addComponent(Transform(0, 0):setLayerOrder(10))

	local emitter_component = Emitter()
    emitter_component:setNumberOfEmissions(50)


  	local recycleWhenOffWorld = function(entity)
    
        local transform = entity:getComponent(Transform)

        if transform.position.x < 0 or transform.position.x > love.graphics.getWidth() 
            or transform.position.y < 0 or transform.position.y > love.graphics.getHeight() then

            emitter_component:recycle(entity)
        
        end

    end 

    local emissionFunction = function()

        local new_entity =  self.world:getEntityManager():createEntity()
        new_entity:addComponent(Transform(400, 300):setLayerOrder(-1))
        new_entity:addComponent(ShapeRendering():setColor(math.random(255), math.random(255), math.random(255)):setShape(CircleShape:new(10)))
        new_entity:addComponent(Motion:new():setVelocity(math.randomPlusOrMinus() * 200 * math.random(), -200 * math.random()):setAcceleration(0, 500))
        new_entity:addComponent(Behavior():addUpdateFunction(recycleWhenOffWorld))
        return new_entity
    end

    emitter_component:setEmissionFunction(emissionFunction)

    local resetFunction = function(reset_entity)

        reset_entity:getComponent(Transform):moveTo(400, 300)
        reset_entity:getComponent(Motion):setVelocity(math.randomPlusOrMinus() * 200 * math.random(), -200 * math.random())
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

    -- Message Response

    local my_messaging = Messaging(self.world:getSystem(MessageSystem))
    self.entity:addComponent(my_messaging)

    my_messaging:registerMessageResponse(Events.BALL_COLLISION_BRICK, function(ball, brick)

    	local bricks = self.world:getEntitiesInGroup(Tags.BRICK_GROUP)
	    local all_disabled = true

	    for brick in bricks:members() do
	        local brick_state = brick:getComponent(StateComponent)
	        if brick_state:getState(Tags.BRICK_ALIVE) then
	            all_disabled = false
	            break
	        end 
	    end

	    if all_disabled then
	       emitter_component:start()
	       emitter_component:makeReady()
	    end

    end)


end

