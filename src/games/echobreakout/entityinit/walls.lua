require 'entity.components.transform'
require 'entity.components.rendering'
require 'entity.components.collider'
require 'entity.components.motion'
require 'entity.components.behavior'
require 'entity.components.inputresponse'
require 'entity.components.soundcomponent'

require 'enums.tags'

Walls = {}

function Walls.init(world)

    local em = world:getEntityManager()

     -- Tends to fall off world
    local TILE_SIZE = 20

    local top_tile = em:createEntity('top_tile')
    top_tile:addComponent(Transform(0, -1 * TILE_SIZE + 1))
    top_tile:addComponent(Collider():setHitbox(RectangleShape:new(love.graphics.getWidth(), TILE_SIZE)))
    top_tile:addComponent(Rendering():addRenderable(ShapeRendering():setColor(147,147,205):setShape(RectangleShape:new(love.graphics.getWidth(), TILE_SIZE))))


    local bottom_tile = em:createEntity('bottom_tile')
    bottom_tile:addComponent(Transform(0, love.graphics.getHeight() - 1))
    bottom_tile:addComponent(Collider():setHitbox(RectangleShape:new(love.graphics.getWidth(), TILE_SIZE)))
    bottom_tile:addComponent(Rendering():addRenderable(ShapeRendering():setColor(147,147,205):setShape(RectangleShape:new(love.graphics.getWidth(), TILE_SIZE))))

    local left_tile = em:createEntity('left_tile')
    left_tile:addComponent(Transform(-1 * TILE_SIZE + 1, 0))
    left_tile:addComponent(Collider():setHitbox(RectangleShape:new(TILE_SIZE, love.graphics.getHeight())))
    left_tile:addComponent(Rendering():addRenderable(ShapeRendering():setColor(147,147,205):setShape(RectangleShape:new(TILE_SIZE, love.graphics.getHeight()))))

    local right_tile = em:createEntity('right_tile')
    right_tile:addComponent(Transform(love.graphics.getWidth() - 1, 0))
    right_tile:addComponent(Collider():setHitbox(RectangleShape:new(TILE_SIZE, love.graphics.getHeight())))
    right_tile:addComponent(Rendering():addRenderable(ShapeRendering():setColor(147,147,205):setShape(RectangleShape:new(TILE_SIZE, love.graphics.getHeight()))))

    world:addEntityToGroup(Tags.WALL_GROUP, top_tile)
    world:addEntityToGroup(Tags.WALL_GROUP, bottom_tile)
    world:addEntityToGroup(Tags.WALL_GROUP, left_tile)
    world:addEntityToGroup(Tags.WALL_GROUP, right_tile)

    world:addEntityToGroup(Tags.PLAY_GROUP, top_tile)
    world:addEntityToGroup(Tags.PLAY_GROUP, bottom_tile)
    world:addEntityToGroup(Tags.PLAY_GROUP, left_tile)
    world:addEntityToGroup(Tags.PLAY_GROUP, right_tile)


end 

return Walls