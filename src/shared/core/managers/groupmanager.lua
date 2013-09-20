require 'external.middleclass'
require 'collections.multimap'

GroupManager = class('GroupManager')

function GroupManager:initialize(world)

        self.entities_by_group = MultiMap()
        self.groups_by_entity = MultiMap()
        self.world = world
end

function GroupManager:removeEntityFromGroup(group, entity)

	self.entities_by_group:remove(group, entity)
	self.groups_by_entity:remove(entity, group)

	return self
end

function GroupManager:addEntityToGroup(group, entity)

	assert(group, "Must have a group parameter")
	assert(entity, "Must have an entity parameter")

	self.entities_by_group:put(group, entity)
	self.groups_by_entity:put(entity, group)

	return self
end


function GroupManager:getEntitiesInGroup(group)
	
	assert(group, "Must have a group parameter")
	return self.entities_by_group:get(group)
	
end

function GroupManager:getGroupsContainingEntity(entity)

	assert(entity, "Must have an entity parameter")
	return self.groups_by_entity:get(entity)
	
end

function GroupManager:__tostring()
	return "GROUP MANAGER: [Entities by group: " .. tostring(self.entities_by_group) .. "; Groups by Entity: " .. tostring(self.groups_by_entity) .. "]"
end