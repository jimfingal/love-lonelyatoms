
GenericBehaviors = {}

function GenericBehaviors.bounceEntityOffWorldEdges(entity)

    local transform = entity:getComponent(Transform)
    local velocity = entity:getComponent(Motion).velocity
    
    -- Horizontally

    if transform.position.x < 0 then
   
        transform.position.x = 1
        velocity.x = -velocity.x 
   
    elseif transform.position.x > love.graphics.getWidth() then
   
        transform.position.x = love.graphics.getWidth() - 1
        velocity.x = -velocity.x 
   
    end

    -- Vertically

    if transform.position.y < 0 then
   
        transform.position.y = 1
        velocity.y = -velocity.y

    elseif transform.position.y > love.graphics.getHeight() then
        
        transform.position.y = love.graphics.getHeight() - 1
        velocity.y = -velocity.y
   
    end

end


function GenericBehaviors.wrapEntityAroundWorldEdges(entity)

    local transform = entity:getComponent(Transform)
    local velocity = entity:getComponent(Motion).velocity
    
    -- Horizontally

    if transform.position.x < 0 then
   
        transform.position.x = love.graphics.getWidth() 
   
    elseif transform.position.x > love.graphics.getWidth() then
   
        transform.position.x = 0
   
    end

    -- Vertically

    if transform.position.y < 0 then
   
        transform.position.y = love.graphics.getHeight()

    elseif transform.position.y > love.graphics.getHeight() then
        
        transform.position.y = 0
   
    end

end

