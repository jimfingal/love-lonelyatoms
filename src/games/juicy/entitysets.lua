require 'core.components.transform'
require 'core.components.rendering'
require 'core.components.collider'
require 'core.components.motion'
require 'core.components.behavior'
require 'core.components.inputresponse'
require 'core.components.soundcomponent'
require 'core.entity.entityquery'

require 'core.vector'


function entitiesRespondingToInput(world)

    local query = EntityQuery()
    query:addOrSet(InputResponse)
    return world:getEntityManager():queryEntities(query)
end

function entitiesWithBehavior(world)
    local query = EntityQuery()
    query:addOrSet(Behavior)
    return world:getEntityManager():queryEntities(query)
end


function entitiesWithMovement(world)

    local query = EntityQuery()
    query:addOrSet(Transform)
    query:addOrSet(Motion)
    return world:getEntityManager():queryEntities(query)

end

function entitiesWithDrawability(world)

    local query = EntityQuery()
    query:addOrSet(Transform, ShapeRendering)
    query:addOrSet(Transform, TextRendering)
    query:addOrSet(Transform, ImageRendering)

    return world:getEntityManager():queryEntities(query)
    
end



