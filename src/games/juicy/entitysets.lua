require 'core.components.transform'
require 'core.components.rendering'
require 'core.components.collider'
require 'core.components.motion'
require 'core.components.behavior'
require 'core.components.inputresponse'
require 'core.components.soundcomponent'
require 'core.vector'




function entitiesRespondingToInput(world)
    local em = world:getEntityManager()
    return em:getAllEntitiesContainingComponent(InputResponse)
end

function entitiesWithBehavior(world)
    local em = world:getEntityManager()
    return em:getAllEntitiesContainingComponent(Behavior)
end


function entitiesWithMovement(world)
    local em = world:getEntityManager()
    return em:getAllEntitiesContainingComponents(Transform, Motion)
end

function entitiesWithDrawability(world)
    local em = world:getEntityManager()

    local drawables = Set()
    drawables:addSet(em:getAllEntitiesContainingComponents(Transform, ShapeRendering))
    drawables:addSet(em:getAllEntitiesContainingComponents(Transform, TextRendering))
    drawables:addSet(em:getAllEntitiesContainingComponents(Transform, ImageRendering))    

    return drawables
end