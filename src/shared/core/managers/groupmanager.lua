require 'external.middleclass'
require 'collections.set'

GroupManager = class('GroupManager')

function GroupManager:initialize(world)
        self.entities_by_group = {}
        self.groups_by_entity = {}

        self.world = world
end

function GroupManager:addEntityToGroup(group, entity)

	assert(group, "Must have a group parameter")
	assert(entity, "Must have an entity parameter")

	-- Put entity into group, initializing set if needed
	local entities = self:getEntitiesInGroup(group)

	if not entities then
		entities = Set()
		self.entities_by_group[group] = entities
	end

	entities:add(entity)

	-- Put entity into group, initializing set if needed
	local groups = self:getGroupsContainingEntity(group)

	if not groups then
		groups = Set()
		self.groups_by_entity[entity] = groups
	end

	groups:add(group)

end

function GroupManager:getEntitiesInGroup(group)
	assert(group, "Must have a group parameter")
	return self.entities_by_group[group]
end

function GroupManager:getGroupsContainingEntity(entity)
	assert(entity, "Must have an entity parameter")
	return self.groups_by_entity[entity]
end
