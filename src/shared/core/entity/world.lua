require 'external.middleclass'
require 'core.entity.entitymanager'
require 'core.managers.groupmanager'
require 'core.managers.tagmanager'

World = class('World')


function World:initialize()
	self.entity_manager = EntityManager(self)
	self.tag_manager = TagManager(self)
	self.group_manager = GroupManager(self)

	self.systems = {}

end

function World:getEntityManager()
	return self.entity_manager
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
	self.group_manager:getEntitiesInGroup(group)

end

function World:getGroupsContainingEntity(entity)
	self.group_manager:getEntitiesInGroup(entity)

end

-- Tags

function World:tagEntity(tag, entity)
	return self.tag_manager:register(tag, entity)
end

function World:getTaggedEntity(tag)
	return self.tag_manager:getEntity(tag)
end