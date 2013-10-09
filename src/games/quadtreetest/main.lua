require 'math.quad.aabb'
require 'math.quad.quadtree'
require 'collections.list'
require 'socket'

DEBUG = true

debug_list = List()
frame = 0
memsize = 0

function love.load()

    local aabb = AABB(0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    root_node = QuadTree(aabb, 0, 2, 10)

    math.randomseed( tonumber(tostring(socket.gettime()):reverse():sub(1,6)) )
    math.random(); math.random(); math.random()

    --[[ root_node:subdivide()
    --recursivelySubdivide(root_node)

    for n in root_node.child_nodes:members() do
        randomlySubdivide(root_node)
    end
    ]]

    mouse = {}
    mouse.aabb = AABB(300, 300, 10, 10)

    square = {}
    square.aabb = AABB(200, 200, 10, 10)

    square2 = {}
    square2.aabb = AABB(200, 215, 5, 5)
end

function love.update(dt)
    frame = frame + 1
    local x, y = love.mouse.getPosition()
    mouse.aabb.x = x
    mouse.aabb.y = y

    root_node:clear()
    root_node:insert(square)
    root_node:insert(square2)
    root_node:insert(mouse)

end

function love.draw()

    love.graphics.setBackgroundColor(63, 63, 63, 255)

    love.graphics.setColor(147,147,205)

    drawQuadTree(root_node)

    love.graphics.setColor(205, 147,176)
    drawAABB(mouse.aabb, "fill")
    drawAABB(square.aabb, "fill")
    drawAABB(square2.aabb, "fill")


    if DEBUG then
        outputDebugText()
    end



end

function outputDebugText()
   
    for i, val in debug_list:members() do
        love.graphics.print(tostring(val), 0, i * 10)
    end
    debug_list:clear()

    local debugstart = 50
    love.graphics.setColor(255, 255, 255)
    love.graphics.print("FPS: " .. love.timer.getFPS(), 50, debugstart + 20)

    frame = frame + 1

    if frame % 10 == 0 then
        memsize = collectgarbage('count')
    end

    love.graphics.print('Memory actually used (in kB): ' .. memsize, 10, debugstart + 320)
    
    love.graphics.print('Mouse is in: ' .. tostring(root_node:getNodeEntityIsIn(mouse)), 10, debugstart + 340)

    local possible_overlaps = root_node:getPossibleOverlaps(mouse)

    love.graphics.print('Possible overlaps: ' .. tostring(possible_overlaps), 10, debugstart + 360)


end




function drawQuadTree(qt)
    love.graphics.setColor(147,147,205)

    drawAABB(qt.aabb)
    --love.graphics.print(tostring(qt.level) .. tostring(qt.aabb), qt.aabb.x, qt.aabb.y + qt.aabb.h / 2)

    for i, node in qt.child_nodes:members() do
        debug_list:append(node)
        drawQuadTree(node)
    end

end


function drawAABB(box, mode)
    love.graphics.rectangle(mode or "line", box.x, box.y, box.w, box.h)
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
