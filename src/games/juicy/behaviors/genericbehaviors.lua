require 'core.components.transform'

function constrainEntityToWorld(entity)

    local transform = entity:getComponent(Transform)
    
    -- Horizontally

    if transform.position.x < 0 then
        transform.position.x = 0
    elseif transform.position.x > love.graphics.getWidth() then
        transform.position.x = love.graphics.getWidth()
    end

    -- Vertically

    if transform.position.y < 0 then
        transform.position.y = 0
    elseif transform.position.y > love.graphics.getHeight() then
        transform.position.y = love.graphics.getHeight()
    end

end
