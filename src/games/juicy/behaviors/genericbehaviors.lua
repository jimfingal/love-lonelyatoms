require 'core.components.transform'

GenericBehaviors = {}

function GenericBehaviors.constrainEntityToWorld(entity)

    local transform = entity:getComponent(Transform)
    
    -- Horizontally

    if transform.position.x < 0 then
        transform.position.x = 1
    elseif transform.position.x > love.graphics.getWidth() then
        transform.position.x = love.graphics.getWidth() - 1
    end

    -- Vertically

    if transform.position.y < 0 then
        transform.position.y = 1
    elseif transform.position.y > love.graphics.getHeight() then
        transform.position.y = love.graphics.getHeight() - 1
    end

end


return GenericBehaviors