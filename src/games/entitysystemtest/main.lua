require 'core.components.transform'
require 'core.components.rendering'
require 'core.systems.renderingsystem'
require 'core.systems.collisionsystem'

require 'core.shapedata'
require 'core.entity.world'

Timer = require 'external.timer'


function love.load()

    love.graphics.setBackgroundColor(63, 63, 63, 255)

    world = World()

    local rendering_system = RenderingSystem()
    local collision_system = CollisionSystem(world)


    world:setSystem(rendering_system)
    world:setSystem(collision_system)


    local em = world:getEntityManager()

    local circle = em:createEntity('circle')
    em:addComponent(circle, Transform(100, 100))
    em:addComponent(circle, Rendering():setColor(205,147,176):setShape(CircleShape:new(50)))
    em:addComponent(circle, Collider():setHitbox(CircleShape:new(50)))


    local rectangle = em:createEntity('rectangle')
    em:addComponent(rectangle, Transform(300, 100))
    em:addComponent(rectangle, Rendering():setColor(205,147,147):setShape(RectangleShape:new(100, 50)))
    em:addComponent(rectangle, Collider():setHitbox(RectangleShape:new(100, 50)))


    local point = em:createEntity('point')
    em:addComponent(point, Transform(500, 100))
    em:addComponent(point, Rendering():setColor(147,147,205):setShape(PointShape:new()))
    em:addComponent(point, Collider():setHitbox(PointShape:new()))


   local  mouse = em:createEntity('mouse')
    mouse_transform = Transform(100, 100)
    mouse_rendering = Rendering():setColor(147,176,205):setShape(CircleShape:new(50))
    mouse_collider = Collider():setHitbox(CircleShape:new(50))

    em:addComponent(mouse, mouse_transform)
    em:addComponent(mouse, mouse_rendering)
    em:addComponent(mouse, mouse_collider)

    periodic = 1

    mouse_transform:moveTo(love.mouse.getPosition())

    input_disabled = false

    collision_system:watchCollision(mouse, circle, function() em:getComponent(circle, Rendering):setFillMode('line') end )
    collision_system:watchCollision(mouse, rectangle, function() em:getComponent(rectangle, Rendering):setFillMode('line') end )
    collision_system:watchCollision(mouse, point, function() love.graphics.setBackgroundColor(50, 50, 50, 255) end )



end

function love.update(dt)

    Timer.update(dt)

   if love.keyboard.isDown(" ") then

     if not input_disabled then

            periodic = periodic + 1
           
            if periodic > 3 then
                periodic = 1
            end

            if periodic == 1 then
                mouse_rendering:setShape(CircleShape:new(50))
                mouse_collider:setHitbox(CircleShape:new(50))
            elseif periodic == 2 then
                mouse_rendering:setShape(RectangleShape:new(100, 50))
                mouse_collider:setHitbox(RectangleShape:new(100, 50))

            elseif periodic == 3 then
                mouse_rendering:setShape(PointShape:new())
                mouse_collider:setHitbox(PointShape:new())

            end

            input_disabled = true

            Timer.add(0.2, function() input_disabled = false end)

       end
    end


    mouse_transform:moveTo(love.mouse.getPosition())

  

end

function love.draw()

    love.graphics.setBackgroundColor(63, 63, 63, 255)

    local em = world:getEntityManager()
    local rendering_system = world:getSystem(RenderingSystem)

    local collision_system = world:getSystem(CollisionSystem)
    collision_system:processCollisions()

    for entity in em:getAllEntitiesContainingComponents(Transform, Rendering):members() do

        t = em:getComponent(entity, Transform)
        r = em:getComponent(entity, Rendering)
        rendering_system:draw(t, r)
        
        -- Hack
        r:setFillMode('fill')
    end



end