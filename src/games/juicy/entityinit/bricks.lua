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


    local bsnd = "background.mp3"

    local this_sound = asset_manager:loadSound(Assets.BACKGROUND_SOUND, bsnd)
    this_sound:setVolume(0.25)
    this_sound:setLooping(true)

    local background_sound_entity = em:createEntity('background_sound')
    background_sound_entity:addComponent(SoundComponent():addSound(Assets.BACKGROUND_SOUND, this_sound))
    world:tagEntity(Tags.BACKGROUND_SOUND, background_sound_entity)
    world:addEntityToGroup(Tags.PLAY_GROUP, background_sound_entity)

    local brick_snd = "brick.mp3"

    asset_manager:loadSound(Assets.BRICK_SOUND, brick_snd)

    for y = 0, 60, 20 do

        local x_start = 0
        local x_end = 700

        if y > 0 and y % 40 == 20 then 
            x_start = 50
            x_end = 650
        end

        for x=x_start, x_end, 100 do

            local brick = em:createEntity('brick' .. y .. x)
            brick:addComponent(Transform(x, y):setLayerOrder(2))
            brick:addComponent(ShapeRendering():setColor(Palette.COLOR_BRICK:unpack()):setShape(RectangleShape:new(50, 20)))
            brick:addComponent(Collider():setHitbox(RectangleShape:new(50, 20)))
            brick:addComponent(SoundComponent():addSound(Assets.BRICK_SOUND, asset_manager:getSound(Assets.BRICK_SOUND)))

            world:addEntityToGroup(Tags.BRICK_GROUP, brick)
            world:addEntityToGroup(Tags.PLAY_GROUP, brick)

        end
    end


end 

return Bricks
