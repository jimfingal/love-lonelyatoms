require 'core.components.transform'
require 'core.components.rendering'
require 'core.components.collider'
require 'core.components.soundcomponent'
require 'core.components.statecomponent'

require 'enums.assets'
require 'enums.tags'
require 'enums.palette'

require 'core.entity.entitybuilder'
local BrickBehaviors = require 'behaviors.brickbehaviors'

require 'external.middleclass'

BrickBuilder  = class('BrickBuilder', EntityBuilder)

function BrickBuilder:initialize(world)
    EntityBuilder.initialize(self, world)
    return self
end

function BrickBuilder:create()

    local asset_manager = self.world:getAssetManager()

    local brick_snd = "brick.wav"

    asset_manager:loadSound(Assets.BRICK_SOUND, brick_snd)

    self:loadBricks()

end

function BrickBuilder:reset()

    local existing_bricks = self.world:getEntitiesInGroup(Tags.BRICK_GROUP)
    
    for brick in existing_bricks:members() do
        brick:kill()
    end

    self:loadBricks()

end

function BrickBuilder:loadBricks()

    local em = self.world:getEntityManager()
    local asset_manager = self.world:getAssetManager()

    local x_start = 80
    local x_end = 680

    for y = 50, 290, 30 do

        for x=x_start, x_end, 60 do

            local brick = em:createEntity('brick' .. y .. x)
            brick:addComponent(Transform(x, y):setLayerOrder(2))
            brick:addComponent(ShapeRendering():setColor(Palette.COLOR_BRICK:unpack()):setShape(RectangleShape:new(50, 20)))
            brick:addComponent(Collider():setHitbox(RectangleShape:new(50, 20)))
            brick:addComponent(SoundComponent():addSound(Assets.BRICK_SOUND, asset_manager:getSound(Assets.BRICK_SOUND)))
            brick:addComponent(StateComponent():setState(Tags.BRICK_ALIVE, true))

            self.world:addEntityToGroup(Tags.BRICK_GROUP, brick)
            self.world:addEntityToGroup(Tags.PLAY_GROUP, brick)


            local my_messaging = Messaging(self.world:getSystem(MessageSystem))
            brick:addComponent(my_messaging)  

        end
    end

end

