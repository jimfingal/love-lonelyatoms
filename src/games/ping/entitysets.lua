require 'entity.components.transform'
require 'entity.components.rendering'
require 'entity.components.collider'
require 'entity.components.motion'
require 'entity.components.behavior'
require 'entity.components.inputresponse'
require 'entity.components.soundcomponent'
require 'math.vector2'
require 'entity.entityquery'


local INPUTTABLE_ENTITIES = EntityQuery():addOrSet(InputResponse)
local BEHAVIOR_ENTITIES = EntityQuery():addOrSet(Behavior)
local MOVABLE_ENTITIES = EntityQuery():addOrSet(Transform):addOrSet(Motion)
local DRAWABLE_ENTITIES =  EntityQuery():addOrSet(Rendering):addOrSet(Transform)


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



