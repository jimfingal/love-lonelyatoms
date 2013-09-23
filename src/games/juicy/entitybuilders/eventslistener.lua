
require 'external.middleclass'
require 'core.entity.entitybuilder'
GlobalEffects = require 'scripts.globaleffects'
EntityEffects = require 'scripts.entityeffects'

BrickBehaviors = require 'behaviors.brickbehaviors'


EventsListenerBuilder  = class('EventsListenerBuilder', EntityBuilder)
require 'behaviors.brickbehaviors'


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

    end)

    pan_message:registerMessageResponse(Events.BALL_COLLISION_BRICK, function(ball, brick)


        local statistics_system = self.world:getStatisticsSystem()
        local time_system = self.world:getTimeSystem()

        statistics_system:addToEventTally(Events.BALL_COLLISION_BRICK)
        BrickBehaviors.playBrickSoundWithAdjustedPitch(brick, statistics_system:timeSinceLastEventOccurence(Events.BALL_COLLISION_BRICK, time_system:getTime()))
        statistics_system:registerTimedEventOccurence(Events.BALL_COLLISION_BRICK, time_system:getTime())

        BrickBehaviors.dispatchBrick(ball, brick)
        
        GlobalEffects.cameraShake(self.world)
        GlobalEffects.slowMo(self.world, 0.5)

    end)

    pan_message:registerMessageResponse(Events.BALL_COLLISION_WALL, function(ball, wall)
        
        local statistics_system = self.world:getStatisticsSystem()
        local time_system = self.world:getTimeSystem()

        statistics_system:addToEventTally(Events.BALL_COLLISION_WALL)
        statistics_system:registerTimedEventOccurence(Events.BALL_COLLISION_WALL, time_system:getTime())

        GlobalEffects.cameraShake(self.world)
        EntityEffects.scaleEntity(wall, 5, 5)


    end)

end