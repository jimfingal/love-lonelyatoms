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

function Bricks.init(world, song)

    local em = world:getEntityManager()

    local existing_bricks = world:getEntitiesInGroup(Tags.BRICK_GROUP)

    local background_snd = world:getTaggedEntity(Tags.BACKGROUND_SOUND)

    if background_snd then
        background_snd:kill()
    end

    for brick in existing_bricks:members() do
        brick:kill()
    end


    local asset_manager = world:getAssetManager()

    if not song then 

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

    else

        local required = 'assets.spritemaps.' .. song

        local config = require(required)

        local asset_manager = world:getAssetManager()
       
        local this_sound =  asset_manager:loadSound(config.background_snd, config.background_snd)
        this_sound:setVolume(0.25)
        this_sound:setLooping(true)

        local background_sound_entity = em:createEntity('background_sound')
        background_sound_entity:addComponent(SoundComponent():addSound(Assets.BACKGROUND_SOUND, this_sound))
        world:tagEntity(Tags.BACKGROUND_SOUND, background_sound_entity)
        world:addEntityToGroup(Tags.PLAY_GROUP, background_sound_entity)


        for _, brickinfo in ipairs(config.bricks) do

            asset_manager:loadSound(brickinfo.snd, brickinfo.snd)

            local brick = em:createEntity('brick' .. brickinfo.x .. brickinfo.y)
            brick:addComponent(Transform(brickinfo.x, brickinfo.y):setLayerOrder(2))
            brick:addComponent(ShapeRendering():setColor(brickinfo.r, brickinfo.g, brickinfo.b):setShape(RectangleShape:new(brickinfo.width, brickinfo.height)))
            brick:addComponent(Collider():setHitbox(RectangleShape:new(brickinfo.width, brickinfo.height)))
            brick:addComponent(SoundComponent():addSound(Assets.BRICK_SOUND, asset_manager:getSound(brickinfo.snd)))

            world:addEntityToGroup(Tags.BRICK_GROUP, brick)
            world:addEntityToGroup(Tags.PLAY_GROUP, brick)

        end
    end

end 

BrickConfig = class('BrickConfig')

function BrickConfig:initialize(name, background_length, song_length, background_snd, speed, bricks)
    self.name = name
    self.background_length = background_length
    self.song_length = song_length
    self.background_snd = background_snd
    self.speed = speed
    self.bricks = bricks
end


return Bricks


