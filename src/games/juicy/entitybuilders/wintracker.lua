
require 'external.middleclass'
require 'entity.entitybuilder'

WinTrackerBuilder  = class('WinTrackerBuilder', EntityBuilder)

function WinTrackerBuilder:initialize(world)
    EntityBuilder.initialize(self, world, 'win tracker')
    return self
end


function checkWinCondition(world)
		
	local bricks = world:getEntitiesInGroup(Tags.BRICK_GROUP)
    local all_disabled = true

    for brick in bricks:members() do
        local brick_state = brick:getComponent(StateComponent)
        if brick_state:getState(Tags.BRICK_ALIVE) then
            all_disabled = false
            break
        end 
    end

    return all_disabled
end

function enableWinDisplay(world)
		
	local em = world:getEntityManager()
	local asset_manager = world:getAssetManager()

	local win_display = em:createEntity('forthewin')
    win_display:addComponent(Transform(300, 200):setLayerOrder(-1))

    local text = TextRendering("You Win!")
    text:setFont(asset_manager:getFont(Assets.FONT_LARGE))
    text:setColor(255, 255, 255)
    win_display:addComponent(Rendering():addRenderable(text))

    local schedule_system = world:getScheduleSystem()

    schedule_system:doEvery(0.1, function()
    	text:setColor(math.random(255), math.random(255), math.random(255))
    end)

end


function WinTrackerBuilder:create()

	EntityBuilder.create(self)

    self.entity:addComponent(Transform(0, 0):setLayerOrder(10))

    local my_messaging = Messaging(self.world:getSystem(MessageSystem))
    self.entity:addComponent(my_messaging)

    my_messaging:registerMessageResponse(Events.BALL_COLLISION_BRICK, function(ball, brick)

	    if checkWinCondition(self.world) then
	       enableWinDisplay(self.world)
	    end

    end)

end





