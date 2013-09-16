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

	if entities:size() == 0 then
		self.entities_by_group[group] = entities
	end

	entities:add(entity)

	-- Put entity into group, initializing set if needed
	local groups = self:getGroupsContainingEntity(group)

	if groups:size() == 0 then
		self.groups_by_entity[entity] = groups
	end

	groups:add(group)

end

function GroupManager:initializeEntitySet(group)

	return
end

function GroupManager:getEntitiesInGroup(group)
	assert(group, "Must have a group parameter")

	-- return self.entities_by_group[group]

	if self.entities_by_group[group] then
		return self.entities_by_group[group]
	else
		return Set:new()		
	end

end

function GroupManager:getGroupsContainingEntity(entity)
	assert(entity, "Must have an entity parameter")

	-- return self.groups_by_entity[entity]

	if self.groups_by_entity[entity] then
		return self.groups_by_entity[entity]
	else
		return Set:new()
	end

end