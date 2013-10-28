require 'entity.components.transform'

--[[
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

]]