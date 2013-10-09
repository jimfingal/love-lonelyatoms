require 'external.middleclass'
require 'entity.entitymanager'
require 'entity.managers.groupmanager'
require 'entity.managers.tagmanager'
require 'entity.managers.scenemanager'
require 'entity.managers.assetmanager'
require 'entity.systems.schedulesystem'
require 'entity.systems.renderingsystem'
require 'entity.systems.collisionsystem'
require 'entity.systems.movementsystem'
require 'entity.systems.behaviorsystem'
require 'entity.systems.camerasystem'
require 'entity.systems.tweensystem'
require 'entity.systems.timesystem'
require 'entity.systems.inputsystem'


World = class('World')

function World:initialize()
	self.entity_manager = EntityManager(self)
	self.tag_manager = TagManager(self)
	self.group_manager = GroupManager(self)
	self.scene_manager = SceneManager(self)
	self.asset_manager = AssetManager("assets/fonts/", "assets/sounds/", "assets/images/")

	self.systems = {}

end

function World:getEntityManager()
	return self.entity_manager
end

function World:getSceneManager()
	return self.scene_manager
end


function World:getAssetManager()
	return self.asset_manager
end


function World:setSystem(system)
	self.systems[system.class] = system
end

function World:getSystem(system_class)
	return self.systems[system_class]
end


--[[ Convenience functions to obfuscate basic managers ]]


-- Groups

function World:addEntityToGroup(group, entity)
	self.group_manager:addEntityToGroup(group, entity)
end

function World:getEntitiesInGroup(group)
	return self.group_manager:getEntitiesInGroup(group)

end

function World:getGroupsContainingEntity(entity)
	return self.group_manager:getGroupsContainingEntity(entity)
end

-- Tags

function World:tagEntity(tag, entity)
	return self.tag_manager:register(tag, entity)
end

function World:getTaggedEntity(tag)
	return self.tag_manager:getEntity(tag)
end


function World:killEntity(entity)

	local groups = self:getGroupsContainingEntity(entity)

	for group in groups:members() do
		self.group_manager:removeEntityFromGroup(group, entity)
	end

	self.entity_manager:killEntity(entity.entity_id)

	-- TODO remove from groups
	-- TODO remove tags

end


-- Convenience System Getters. To reduce amount of code that loads,
-- can comment these and includes above out, and use generic getter above.

function World:getInputSystem()
	return self:getSystem(InputSystem)
end

function World:getScheduleSystem()
	return self:getSystem(ScheduleSystem)
end

function World:getTimeSystem()
	return self:getSystem(TimeSystem)
end

function World:getStatisticsSystem()
	return self:getSystem(StatisticsSystem)
end

function World:getRenderingSystem()
	return self:getSystem(RenderingSystem)
end

function World:getTweenSystem()
	return self:getSystem(TweenSystem)
end

function World:getBehaviorSystem()
	return self:getSystem(BehaviorSystem)
end

function World:getCollisionSystem()
	return self:getSystem(CollisionSystem)
end

function World:getMovementSystem()
	return self:getSystem(MovementSystem)
end

function World:getMessageSystem()
	return self:getSystem(MessageSystem)
end