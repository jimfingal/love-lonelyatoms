require 'core.components.transform'
require 'core.components.rendering'
require 'core.components.collider'
require 'core.components.motion'
require 'core.components.behavior'
require 'core.components.inputresponse'
require 'core.components.soundcomponent'

require 'enums.assets'
require 'enums.tags'
require 'enums.palette'

Bricks = {}


function Bricks.init(world)

    local em = world:getEntityManager()

    local existing_bricks = world:getEntitiesInGroup(Tags.BRICK_GROUP)

    local asset_manager = world:getAssetManager()

    for brick in existing_bricks:members() do
        brick:kill()
    end


    local brick_snd = "brick.mp3"

    asset_manager:loadSound(Assets.BRICK_SOUND, brick_snd)

    local tween_system = world:getSystem(TweenSystem)

    local x_start = 80
    local x_end = 680

    for y = 50, 290, 30 do

        for x=x_start, x_end, 60 do

            local brick = em:createEntity('brick' .. y .. x)
            -- brick:addComponent(Transform(x, y - 300):setLayerOrder(2))
            brick:addComponent(Transform(x, y):setLayerOrder(2))
            brick:addComponent(ShapeRendering():setColor(Palette.COLOR_BRICK:unpack()):setShape(RectangleShape:new(50, 20)))
            brick:addComponent(Collider():setHitbox(RectangleShape:new(50, 20)))
            brick:addComponent(SoundComponent():addSound(Assets.BRICK_SOUND, asset_manager:getSound(Assets.BRICK_SOUND)))

            world:addEntityToGroup(Tags.BRICK_GROUP, brick)
            world:addEntityToGroup(Tags.PLAY_GROUP, brick)

            --[[ 
            tween_system:addTween(1 + math.random(), brick:getComponent(ShapeRendering):getShape(), {width = 50, height = 20}, Easing.outBounce)
            tween_system:addTween(1 + math.random(), brick:getComponent(Transform):getPosition(), {x = x, y = y}, Easing.outBounce)
            tween_system:addTween(1 + math.random(), brick:getComponent(Transform), {rotation = 2 * math.pi }, Easing.outBounce)
            ]]
        end
    end


end 

return Bricks
