require 'core.entity.entitymanager'
require 'core.entity.component'
require 'core.entity.metaentity'
require 'core.entity.world'

require 'external.middleclass'

Tags = {}

Tags.WALL_GROUP = "walls"
Tags.PLAY_GROUP = "playgroup"



world = World()

local gm = world.group_manager


local em = world:getEntityManager()
local top_tile = em:createEntity('top_tile') 
  

print("adding tiles to wall group")
world:addEntityToGroup(Tags.WALL_GROUP, top_tile)


print("Entities in wall group: " .. tostring(gm.entities_by_group[Tags.WALL_GROUP]))
print("Groups that top tile is in: " .. tostring(gm.groups_by_entity[top_tile]))


wall_entities = world:getEntitiesInGroup(Tags.WALL_GROUP)

assert(wall_entities:contains(top_tile), "Wall entities should contain all tiles")


print("adding tiles to Play group")
world:addEntityToGroup(Tags.PLAY_GROUP, top_tile)


print("Entities in play group: " .. tostring(gm.entities_by_group[Tags.PLAY_GROUP]))
print("Entities in wall group: " .. tostring(gm.entities_by_group[Tags.WALL_GROUP]))
print("Groups that top tile is in: " .. tostring(gm.groups_by_entity[top_tile]))

wall_entities = world:getEntitiesInGroup(Tags.WALL_GROUP)
play_entities = world:getEntitiesInGroup(Tags.PLAY_GROUP)



assert(wall_entities:contains(top_tile), "Wall entities should contain all tiles")
assert(play_entities:contains(top_tile), "Play entities should contain all tiles")


tile_groups = world:getGroupsContainingEntity(top_tile)
assert(tile_groups:contains(Tags.PLAY_GROUP), "Tile should be in play group")
assert(tile_groups:contains(Tags.WALL_GROUP), "Tile should be in wall group")


