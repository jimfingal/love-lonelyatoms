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
    circle:addComponent(Transform(100, 100))
    circle:addComponent(ShapeRendering():setColor(205,147,176):setShape(CircleShape:new(50)))
    circle:addComponent(Collider():setHitbox(CircleShape:new(50)))
    world:tagEntity("circle", circle)

    local rectangle = em:createEntity('rectangle')
    rectangle:addComponent(Transform(300, 100))
    rectangle:addComponent(ShapeRendering():setColor(205,147,147):setShape(RectangleShape:new(100, 50)))
    rectangle:addComponent(Collider():setHitbox(RectangleShape:new(100, 50)))
    world:tagEntity("rectangle", rectangle)


    local point = em:createEntity('point')
    point:addComponent(Transform(500, 100))
    point:addComponent(ShapeRendering():setColor(147,147,205):setShape(PointShape:new()))
    point:addComponent(Collider():setHitbox(PointShape:new()))
    world:tagEntity("point", point)


    local  mouse = em:createEntity('mouse')
    mouse:addComponent(Transform(100, 100))
    mouse:addComponent(ShapeRendering():setColor(147,176,205):setShape(CircleShape:new(50)))
    mouse:addComponent(Collider():setHitbox(CircleShape:new(50)))


    world:tagEntity("mouse", mouse)


    periodic = 1


    input_disabled = false

    collision_system:watchCollision(mouse, circle)
    collision_system:watchCollision(mouse, rectangle)
    collision_system:watchCollision(mouse, point)



end

function love.update(dt)

    Timer.update(dt)

   if love.keyboard.isDown(" ") then

     if not input_disabled then

            local mouse_rendering = world:getTaggedEntity("mouse"):getComponent(ShapeRendering)
            local mouse_transform = world:getTaggedEntity("mouse"):getComponent(Transform)
            local mouse_collider = world:getTaggedEntity("mouse"):getComponent(Collider)

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

    local mouse_transform = world:getTaggedEntity("mouse"):getComponent(Transform)
    mouse_transform:moveTo(love.mouse.getPosition())

  
    local collision_system = world:getSystem(CollisionSystem)

    collisions = collision_system:getCollisions()
    local em = world:getEntityManager()


    -- TODO: don't have if / elses
    for collision_event in collisions:members() do

        
        if collision_event.a == world:getTaggedEntity("mouse") and
            collision_event.b == world:getTaggedEntity("circle") then
            
            local circle = world:getTaggedEntity("circle")
            circle:getComponent(ShapeRendering):setFillMode('line')

        elseif collision_event.a == world:getTaggedEntity("mouse") and
            collision_event.b == world:getTaggedEntity("rectangle") then
            
            local rectangle = world:getTaggedEntity("rectangle")
            rectangle:getComponent(ShapeRendering):setFillMode('line')

        elseif collision_event.a == world:getTaggedEntity("mouse") and
            collision_event.b == world:getTaggedEntity("point") then
            
            love.graphics.setBackgroundColor(50, 50, 50, 255)

        end
    
    end
   


end

function love.draw()

    love.graphics.setBackgroundColor(63, 63, 63, 255)

    local em = world:getEntityManager()
    local rendering_system = world:getSystem(RenderingSystem)


    world:getSystem(RenderingSystem):renderDrawables(em:getAllEntitiesContainingComponents(Transform, ShapeRendering))

        -- Hack
        -- r:setFillMode('fill')
    


end