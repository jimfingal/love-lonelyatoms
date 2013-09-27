require 'core.components.transform'
require 'core.components.rendering'
require 'core.components.collider'
require 'core.components.motion'
require 'core.components.behavior'
require 'core.components.inputresponse'
require 'core.components.soundcomponent'
require 'core.vector'
require 'core.entity.entityquery'


local INPUTTABLE_ENTITIES = EntityQuery():addOrSet(InputResponse)
local BEHAVIOR_ENTITIES = EntityQuery():addOrSet(Behavior)
local MOVABLE_ENTITIES = EntityQuery():addOrSet(Transform):addOrSet(Motion)
local DRAWABLE_ENTITIES =  EntityQuery():addOrSet(TextRendering, ShapeRendering, ImageRendering):addOrSet(Transform)


function entitiesRespondingToInput(world)
    local em = world:getEntityManager()
    return em:query(INPUTTABLE_ENTITIES)
end

function entitiesWithBehavior(world)
    local em = world:getEntityManager()
    return em:query(BEHAVIOR_ENTITIES)
end


function entitiesWithMovement(world)
    local em = world:getEntityManager()
    return em:query(MOVABLE_ENTITIES)
end

function entitiesWithDrawability(world)
    local em = world:getEntityManager()
    return em:query(DRAWABLE_ENTITIES)
end



