require 'external.middleclass'
require 'core.entity.entitybuilder'

local GlobalEffects = require 'scripts.globaleffects'
local EntityEffects = require 'scripts.entityeffects'
local BrickBehaviors = require 'behaviors.brickbehaviors'

EventsListenerBuilder  = class('EventsListenerBuilder', EntityBuilder)


function EventsListenerBuilder:initialize(world)
    EntityBuilder.initialize(self, world, 'panopticon')
    return self
end

function EventsListenerBuilder:create()

    EntityBuilder.create(self)

    local message_system = self.world:getSystem(MessageSystem)

    self.entity:tag(Tags.PANOPTICON)

    local my_messaging = Messaging(self.world:getSystem(MessageSystem))
    
    self.entity:addComponent(my_messaging)

    my_messaging:registerMessageResponse(Events.BALL_COLLISION_PLAYER, function(ball, player)

        local statistics_system = self.world:getStatisticsSystem()
        local time_system = self.world:getTimeSystem()

        statistics_system:addToEventTally(Events.BALL_COLLISION_PLAYER)
        statistics_system:registerTimedEventOccurence(Events.BALL_COLLISION_PLAYER, time_system:getTime())

        GlobalEffects.cameraShake(self.world)

        local confetti_maker = self.world:getTaggedEntity(Tags.CONFETTI_MAKER)
        EntityEffects.emitConfetti(confetti_maker, ball)

    end)

    my_messaging:registerMessageResponse(Events.BALL_COLLISION_BRICK, function(ball, brick)


        local statistics_system = self.world:getStatisticsSystem()
        local time_system = self.world:getTimeSystem()

        statistics_system:addToEventTally(Events.BALL_COLLISION_BRICK)
        BrickBehaviors.playBrickSoundWithAdjustedPitch(brick, statistics_system:timeSinceLastEventOccurence(Events.BALL_COLLISION_BRICK, time_system:getTime()))
        statistics_system:registerTimedEventOccurence(Events.BALL_COLLISION_BRICK, time_system:getTime())

        BrickBehaviors.dispatchBrick(ball, brick)
        EntityEffects.glitchColors(ball)
        EntityEffects.glitchColors(brick)

        GlobalEffects.cameraShake(self.world)
        -- GlobalEffects.slowMo(self.world, 0.5)

        local confetti_maker = self.world:getTaggedEntity(Tags.CONFETTI_MAKER)
        EntityEffects.emitConfetti(confetti_maker, ball)


    end)

    my_messaging:registerMessageResponse(Events.BALL_COLLISION_WALL, function(ball, wall)
        
        local statistics_system = self.world:getStatisticsSystem()
        local time_system = self.world:getTimeSystem()

        statistics_system:addToEventTally(Events.BALL_COLLISION_WALL)
        statistics_system:registerTimedEventOccurence(Events.BALL_COLLISION_WALL, time_system:getTime())

        GlobalEffects.cameraShake(self.world)
        EntityEffects.scaleEntity(wall, 5, 5)

        EntityEffects.glitchColors(ball)
        local background = self.world:getTaggedEntity(Tags.BACKGROUND)
        EntityEffects.glitchColors(background)

        local confetti_maker = self.world:getTaggedEntity(Tags.CONFETTI_MAKER)
        EntityEffects.emitConfetti(confetti_maker, ball)

    end)

    my_messaging:registerMessageResponse(Events.GAME_RESET, function()
        if Settings.BRICKS_DROPIN then
            BrickBehaviors.dropInBricks(self.world)
        end
    end)

end