require 'core.components.transform'
require 'core.components.rendering'
require 'core.components.collider'
require 'core.components.motion'
require 'core.components.behavior'
require 'core.components.inputresponse'
require 'core.components.soundcomponent'

require 'enums.assets'
require 'enums.tags'

Bricks = {}

function Bricks.init(world)

    local em = world:getEntityManager()



    -- Bricks
    local c1 = 205
    local c2 = 147
    local c3 = 176
        
    local colors = List()

    colors:append(Color:new(c1, c2, c2))
    colors:append(Color:new(c1, c2, c3))
    colors:append(Color:new(c1, c2, c1))
    colors:append(Color:new(c3, c2, c1))
    colors:append(Color:new(c2, c2, c1))
    colors:append(Color:new(c2, c3, c1))
    colors:append(Color:new(c2, c1, c1))
    colors:append(Color:new(c2, c1, c3))
    colors:append(Color:new(c2, c1, c2))
    colors:append(Color:new(c3, c1, c2))

    local brick_snd = "brick.mp3"

    local asset_manager = world:getAssetManager()
    asset_manager:loadSound(Assets.BRICK_SOUND, brick_snd)


    for y = 0, 60, 20 do

        local x_start = 0
        local x_end = 700

        if y > 0 and y % 40 == 20 then 
            x_start = 50
            x_end = 650
        end

        for x=x_start, x_end, 100 do

            local random = math.random(1, colors:size())

            local this_color = colors:memberAt(random)

            local brick = em:createEntity('brick' .. y .. x)
            brick:addComponent(Transform(x, y):setLayerOrder(2))
            brick:addComponent(ShapeRendering():setColor(this_color:unpack()):setShape(RectangleShape:new(100, 20)))
            brick:addComponent(Collider():setHitbox(RectangleShape:new(100, 20)))
            brick:addComponent(SoundComponent():addSound(Assets.BRICK_SOUND, asset_manager:getSound(Assets.BRICK_SOUND)))

            world:addEntityToGroup(Tags.BRICK_GROUP, brick)
            world:addEntityToGroup(Tags.PLAY_GROUP, brick)

        end
    end

end 

return Bricks