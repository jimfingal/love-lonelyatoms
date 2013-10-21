Easing = require 'external.easing'


GenericBehaviors = {}

function GenericBehaviors.fadeTextInAndOut(entity, fadeIn, remain, fadeOut)

    local tween_system = entity:getWorld():getTweenSystem()
    local rendering = entity:getComponent(Rendering):getRenderable()

    local fadeOut = function() 
        tween_system:addTween(fadeOut, rendering.color, {alpha = 0}, Easing.linear)
    end

    -- Minor hack, tweening from 255 to 255
    local wait = function() 
        tween_system:addTween(remain, rendering.color, {alpha = 255}, Easing.linear, fadeOut)
    end

    tween_system:addTween(fadeIn, rendering.color, {alpha = 255}, Easing.linear, wait)

end


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


function GenericBehaviors.dropIn(entity, world)

    local tween_system = world:getSystem(TweenSystem)

    local transform = entity:getComponent(Transform)
    local oldx = transform:getPosition().x
    local oldy = transform:getPosition().y

    transform:move(0, -300)

    local drop_tween = 1 + math.random()

    tween_system:addTween(drop_tween, entity:getComponent(Transform):getPosition(), {x = oldx, y = oldy}, Easing.outBounce)

end

return GenericBehaviors

