require 'core.quad.aabb'
require 'core.quad.quadtree'
require 'collections.list'
require 'socket'

DEBUG = true

debug_list = List()

function love.load()

    local aabb = AABB(0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    root_node = QuadTree(2, aabb, 0, 10, 5)

    math.randomseed( tonumber(tostring(socket.gettime()):reverse():sub(1,6)) )
    math.random(); math.random(); math.random()

    root_node:subdivide()
    randomlySubdivide(root_node)

end

function love.update(dt)


end

function love.draw()

    love.graphics.setBackgroundColor(63, 63, 63, 255)


    drawQuadTree(root_node)

    for i, val  in debug_list:members() do
        love.graphics.print(tostring(val), 0, i * 10)
    end
    debug_list:clear()

end

function drawQuadTree(qt)

    drawAABB(qt.aabb)
    --love.graphics.print(tostring(qt.level) .. tostring(qt.aabb), qt.aabb.x, qt.aabb.y + qt.aabb.h / 2)

    for i, node in qt.child_nodes:members() do
        --debug_list:append(node)
        drawQuadTree(node)
    end

end


function drawAABB(box)
    love.graphics.setColor(147,147,205)
    love.graphics.rectangle("line", box.x, box.y, box.w, box.h)
end


function recursivelySubdivide(qt)

    for i, n in qt.child_nodes:members() do

        if n.level < n.max_level then

            n:subdivide()
            recursivelySubdivide(n)

        end
    end

end


function randomlySubdivide(qt)


    if qt.level < qt.max_level then

        if math.random(5) < 3 then

            qt:subdivide()

            for i, n in qt.child_nodes:members() do
                randomlySubdivide(n)
            end
        end
    end

end
