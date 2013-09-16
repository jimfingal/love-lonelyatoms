require 'external.middleclass'
require 'core.entity.entitymanager'
require 'core.managers.groupmanager'
require 'core.managers.tagmanager'
require 'core.managers.scenemanager'
require 'core.managers.assetmanager'

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