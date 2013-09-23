
require 'external.middleclass'
require 'core.entity.entitybuilder'
GlobalEffects = require 'scripts.globaleffects'
require 'scripts.oldeffects'


EventsListenerBuilder  = class('EventsListenerBuilder', EntityBuilder)

function EventsListenerBuilder:initialize(world)
    EntityBuilder.initialize(self, world, 'panopticon')
    return self
end

function EventsListenerBuilder:create()

    EntityBuilder.create(self)

    local message_system = self.world:getSystem(MessageSystem)

    self.entity:tag(Tags.PANOPTICON)

    local pan_message = Messaging(self.world:getSystem(MessageSystem))
    
    self.entity:addComponent(pan_message)

    pan_message:registerMessageResponse(Events.BALL_COLLISION_PLAYER, function(ball, player)

        local statistics_system = self.world:getStatisticsSystem()
        local time_system = self.world:getTimeSystem()

        statistics_system:addToEventTally(Events.BALL_COLLISION_PLAYER)
        statistics_system:registerTimedEventOccurence(Events.BALL_COLLISION_PLAYER, time_system:getTime())

        GlobalEffects.cameraShake(self.world)
        allEffects(ball, 2, 1.5)
        scaleEntity(player, 1.5, 1.3)
        --EffectDispatcher.rotateJitter(player, 1)

    end)

    pan_message:registerMessageResponse(Events.BALL_COLLISION_BRICK, function(ball, brick)


        local statistics_system = self.world:getStatisticsSystem()
        local time_system = self.world:getTimeSystem()

        statistics_system:addToEventTally(Events.BALL_COLLISION_BRICK)
        playBrickSoundWithAdjustedPitch(brick, statistics_system:timeSinceLastEventOccurence(Events.BALL_COLLISION_BRICK, time_system:getTime()))
        statistics_system:registerTimedEventOccurence(Events.BALL_COLLISION_BRICK, time_system:getTime())

        dispatchBrick(ball, brick)
        GlobalEffects.cameraShake(self.world)
        allEffects(ball, 2, 1.5)
        GlobalEffects.slowMo(self.world, 0.5)
        -- cameraZoom(brick)

    end)

    pan_message:registerMessageResponse(Events.BALL_COLLISION_WALL, function(ball, wall)
        
        local statistics_system = self.world:getStatisticsSystem()
        local time_system = self.world:getTimeSystem()

        statistics_system:addToEventTally(Events.BALL_COLLISION_WALL)
        statistics_system:registerTimedEventOccurence(Events.BALL_COLLISION_WALL, time_system:getTime())

        GlobalEffects.cameraShake(self.world)
        allEffects(ball, 2, 1.5)
        scaleEntity(wall, 5, 5)

    end)

end