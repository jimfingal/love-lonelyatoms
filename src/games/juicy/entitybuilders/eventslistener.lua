
require 'external.middleclass'
require 'core.entity.entitybuilder'

EventsListenerBuilder  = class('EventsListenerBuilder', EntityBuilder)

function EventsListenerBuilder:initialize(world)
    EntityBuilder.initialize(self, world, 'panopticon')
    return self
end

function EventsListenerBuilder:create()

    EntityBuilder.create(self)

    local message_system = self.world:getSystem(MessageSystem)

    self.entity:tag(Tags.PANOPTICON)

    local pan_message = Messaging(world:getSystem(MessageSystem))
    
    self.entity:addComponent(pan_message)

    pan_message:registerMessageResponse(Events.BALL_COLLISION_PLAYER, function(ball, player)

        local statistics_system = world:getStatisticsSystem()
        local time_system = world:getTimeSystem()

        statistics_system:addToEventTally(Events.BALL_COLLISION_PLAYER)
        statistics_system:registerTimedEventOccurence(Events.BALL_COLLISION_PLAYER, time_system:getTime())

        GlobalEffects.cameraShake(world)
        EffectDispatcher.allEffects(ball, 2, 1.5)
        EffectDispatcher.scaleEntity(player, 1.5, 1.3)
        --EffectDispatcher.rotateJitter(player, 1)

    end)

    pan_message:registerMessageResponse(Events.BALL_COLLISION_BRICK, function(ball, brick)


        local statistics_system = world:getStatisticsSystem()
        local time_system = world:getTimeSystem()

        statistics_system:addToEventTally(Events.BALL_COLLISION_BRICK)
        EffectDispatcher.playBrickSoundWithAdjustedPitch(brick, statistics_system:timeSinceLastEventOccurence(Events.BALL_COLLISION_BRICK, time_system:getTime()))
        statistics_system:registerTimedEventOccurence(Events.BALL_COLLISION_BRICK, time_system:getTime())

        EffectDispatcher.dispatchBrick(ball, brick)
        GlobalEffects.cameraShake(world)
        EffectDispatcher.allEffects(ball, 2, 1.5)
        GlobalEffects.slowMo(world, 0.5)
        --EffectDispatcher.cameraZoom(brick)

    end)

    pan_message:registerMessageResponse(Events.BALL_COLLISION_WALL, function(ball, wall)
        
        local statistics_system = world:getStatisticsSystem()
        local time_system = world:getTimeSystem()

        statistics_system:addToEventTally(Events.BALL_COLLISION_WALL)
        statistics_system:registerTimedEventOccurence(Events.BALL_COLLISION_WALL, time_system:getTime())

        GlobalEffects.cameraShake(world)
        EffectDispatcher.allEffects(ball, 2, 1.5)
        EffectDispatcher.scaleEntity(wall, 5, 5)


    end)

end