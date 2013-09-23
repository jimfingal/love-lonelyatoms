
require 'external.middleclass'
require 'core.entity.entitybuilder'

BackgroundImageBuilder  = class('BackgroundImageBuilder', EntityBuilder)

function BackgroundImageBuilder:initialize(world)
    EntityBuilder.initialize(self, world, 'playfield background image')
    return self
end

function BackgroundImageBuilder:create()

	EntityBuilder.create(self)

    self.entity:addComponent(Transform(0, 0):setLayerOrder(10))
    self.entity:addComponent(ShapeRendering():setColor(Palette.COLOR_BACKGROUND:unpack()):setShape(RectangleShape:new(love.graphics.getWidth(), love.graphics.getHeight())))
    self.entity:tag(Tags.BACKGROUND)
    self.entity:addToGroup(Tags.PLAY_GROUP)
    
end