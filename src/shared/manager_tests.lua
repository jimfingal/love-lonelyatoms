require 'core.managers.groupmanager'
require 'core.entity.world'

local gm = GroupManager()

g = "WALLS"
e = "LEFT WALL"

print("Adding [" .. e .. "] to group [" .. g .. "]")
gm:addEntityToGroup(g, e)

assert(gm.entities_by_group[g]:contains(e), "Entity should be added to entities_by_group map")
assert(gm.groups_by_entity[e]:contains(g), "Group should be added to groups_by_entity map")

entities = gm:getEntitiesInGroup(g)

print('Entities set :: ' .. tostring(entities))

assert(entities:contains(e), "Entity should be returned by getEntitiesInGroup")

groups = gm:getGroupsContainingEntity(e)

print('Groups set :: ' .. tostring(groups))

assert(groups:contains(g), "Group should be returned by getGroupsContainingEntity")
	

-- function GroupManager:getEntitiesInGroup(group)
	
-- function GroupManager:getGroupsContainingEntity(entity)

print "testing world helpers"
local world = World()

world:addEntityToGroup(g, e)
assert(world.group_manager.entities_by_group[g]:contains(e), "Entity should be added to entities_by_group map")
assert(world.group_manager.groups_by_entity[e]:contains(g), "Group should be added to groups_by_entity map")

local world_entities = world:getEntitiesInGroup(g)

print('World Entities set :: ' .. tostring(world_entities))

assert(world_entities:contains(e), "Entity should be returned by getEntitiesInGroup")

local world_groups = world:getGroupsContainingEntity(e)

print('World Groups set :: ' .. tostring(world_groups))

assert(world_groups:contains(g), "Group should be returned by getGroupsContainingEntity")