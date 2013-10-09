require 'entity.components.transform'
require 'entity.components.rendering'
require 'entity.systems.renderingsystem'
require 'entity.systems.collisionsystem'
require 'entity.systems.inputsystem'

require 'game.shapedata'
require 'entity.world'

require 'game.tween'
Easing = require 'external.easing'
require 'entity.systems.tweensystem'
require 'entity.systems.schedulesystem'

function love.load()

    love.graphics.setBackgroundColor(63, 63, 63, 255)

    world = World()

    local rendering_system = RenderingSystem()
    local collision_system = CollisionSystem(world)
    local input_system = InputSystem()
    local tween_system = TweenSystem()
    local schedule_system = ScheduleSystem()

    input_system:registerInput(" ", "change")

    world:setSystem(rendering_system)
    world:setSystem(collision_system)
    world:setSystem(input_system)
    world:setSystem(tween_system)
    world:setSystem(schedule_system)


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




    revertSize = function()
            world:getSystem(TweenSystem):addTween(0.5, 
                world:getTaggedEntity("rectangle"):getComponent(Transform):getScale(), 
                {x = 1, y = 1 }, 
                Easing.linear, 
                getBig)
            
    end

    getBig = function()
            world:getSystem(TweenSystem):addTween(0.5, 
                world:getTaggedEntity("rectangle"):getComponent(Transform):getScale(), 
                {x = 2, y = 2 }, 
                Easing.linear, 
                revertSize)
    end



    revertSize = function()
            world:getSystem(TweenSystem):addTween(0.5, 
                world:getTaggedEntity("rectangle"):getComponent(Transform):getScale(), 
                {x = 1, y = 1 }, 
                Easing.linear, 
                getBig)
            
    end

    schedule_system:doFor(math.huge, function(dt)
                    transform = world:getTaggedEntity("rectangle"):getComponent(Transform)
                    transform.rotation = transform.rotation + 3 * love.timer.getDelta()
                end)

    --[[
    rotate2 = function()
            world:getSystem(TweenSystem):addTween(1, 
                world:getTaggedEntity("rectangle"):getComponent(Transform), 
                {rotation = 0 }, 
                Easing.linear, 
                rotate1)
    end

    rotate = function()
            world:getSystem(TweenSystem):addTween(1, 
                world:getTaggedEntity("rectangle"):getComponent(Transform), 
                {rotation = 2 * math.pi}, 
                Easing.linear, 
                rotate2)
    end
    ]]

    getBig()
   --  rotate()

    world:tagEntity("mouse", mouse)


    periodic = 1


    input_disabled = false

    collision_system:watchCollision(mouse, circle)
    collision_system:watchCollision(mouse, rectangle)
    collision_system:watchCollision(mouse, point)



end

function love.update(dt)

    world:getSystem(ScheduleSystem):update(dt)

    local tween_system = world:getSystem(TweenSystem)
    tween_system:update(dt)

    local input_system = world:getSystem(InputSystem)
    input_system:update(dt)

   if input_system:newAction("change") then

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

    for e in em:getAllEntitiesContainingComponent(ShapeRendering):members() do
        e:getComponent(ShapeRendering):setFillMode('fill')
    end


end