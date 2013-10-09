require 'external.middleclass'
require 'entity.system'
require 'entity.components.messaging'
require 'collections.set'
require 'util.tally'

StatisticsSystem = class('StatisticsSystem', System)

--[[ Simple Message Bus. Keeps track of who is listening
	 to what kind of messages, and forwards them if someone sends that message. ]] 

function StatisticsSystem:initialize()

	System.initialize(self, 'Statistics System')

	self.tally = Tally()
	self.last_event_occurance = {}

end

function StatisticsSystem:addToEventTally(event)
	self.tally:increment(event)
	return self
end

function StatisticsSystem:getEventTally(event)
	return self.tally:getCount(event)
end

function StatisticsSystem:registerTimedEventOccurence(event, current_time)
	self.last_event_occurance[event] = current_time
	return self
end

function StatisticsSystem:timeSinceLastEventOccurence(event, current_time)
	
	local last_time = self.last_event_occurance[event]
	if not last_time then return math.huge end
	return current_time - last_time

end