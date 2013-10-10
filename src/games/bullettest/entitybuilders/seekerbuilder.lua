
require 'external.middleclass'
require 'entity.entitybuilder'

require 'enums.palette'
require 'enums.tags'
require 'enums.actions'


require 'entitybuilders.emissionport'
require 'particles.playerbulletparticle'

Steering = require 'game.ai.steering'

require 'socket'

SeekerBuilder  = class('SeekerBuilder', EntityBuilder)

function SeekerBuilder:initialize(world)
    EntityBuilder.initialize(self, world, 'seeker')
    return self
end

function SeekerBuilder:create()

	EntityBuilder.create(self)

    self.entity:addComponent(Transform(397, 500))
    self.entity:addComponent(Rendering():addRenderable(ShapeRendering():setColor(Palette.COLOR_SEEKER:unpack()):setShape(RectangleShape:new(10, 10))))
    self.entity:addComponent(Motion():setDrag(50, 50):setMaxAcceleration(600, 0):setMaxVelocity(300, 0))
    self.entity:tag(Tags.SEEKER)


    local behavior = Behavior()

    local mothership = self.entity:getWorld():getTaggedEntity(Tags.MOTHERSHIP)

    local seekerAI = function()

        Steering.seek(self.entity, mothership, 10000, math.huge)

    end

    behavior:addRoutine(seekerAI)

    behavior:addUpdateFunction(GenericBehaviors.bounceEntityOffWorldEdges)

    self.entity:addComponent(behavior)


end




