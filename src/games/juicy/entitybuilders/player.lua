require 'core.components.transform'
require 'core.components.rendering'
require 'core.components.collider'
require 'core.components.motion'
require 'core.components.behavior'
require 'core.components.inputresponse'
require 'core.components.soundcomponent'

require 'behaviors.genericbehaviors'

require 'enums.tags'
require 'enums.palette'

local PlayerBehaviors = require 'behaviors.playerbehaviors'
require 'external.middleclass'
require 'core.entity.entitybuilder'

PlayerBuilder  = class('PlayerBuilder', EntityBuilder)

function PlayerBuilder:initialize(world)
    EntityBuilder.initialize(self, world, 'player')
    return self
end

function PlayerBuilder:create()

    EntityBuilder.create(self)

    self.entity:addComponent(Transform(350, 500))
    self.entity:addComponent(ShapeRendering():setColor(Palette.COLOR_PADDLE:unpack()):setShape(RectangleShape:new(100, 30)))
    self.entity:addComponent(Collider():setHitbox(RectangleShape:new(100, 30)))
    self.entity:addComponent(Motion():setMaxVelocity(800, 0):setMinVelocity(-800, 0):setDrag(800, 0))

    self.entity:tag(Tags.PLAYER)
    self.entity:addToGroup(Tags.PLAY_GROUP)

    local behavior = Behavior()
    behavior:addUpdateFunction(constrainEntityToWorld)
    self.entity:addComponent(behavior)

    self.entity:addComponent(InputResponse():addResponse(PlayerBehaviors.playerInputResponse))

    local my_messaging = Messaging(self.world:getSystem(MessageSystem))
    
    self.entity:addComponent(my_messaging)

    my_messaging:registerMessageResponse(Events.BALL_COLLISION_PLAYER, function(ball, player)
        EntityEffects.scaleEntity(player, 1.5, 1.3)
    end)

    my_messaging:registerMessageResponse(Events.BALL_COLLISION_PLAYER, function(ball, player)
        EntityEffects.scaleEntity(player, 1.5, 1.3)
    end)

    my_messaging:registerMessageResponse(Events.PLAYER_COLLISION_WALL, function(player, wall)
        PlayerBehaviors.collidePlayerWithWall(player, wall)
    end)

     my_messaging:registerMessageResponse(Events.GAME_RESET, function()
        if Settings.PLAYER_DROPIN then
            PlayerBehaviors.dropInPlayer(self.world)
        end
    end)

end 