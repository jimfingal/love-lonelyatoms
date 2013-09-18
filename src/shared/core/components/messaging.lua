require 'external.middleclass'
require 'core.entity.component'

Messaging = class('Messaging', Component)

-- Passed some update function that
function Messaging:initialize(message_system)

	assert(message_system, "Must attach to a message system")
	Component.initialize(self, 'Messaging')
	
	self.message_system = message_system
	self.message_responses = {}

end

function Messaging:stopListeningTo(key)
	self.message_responses[key] = nil
	self.message_system:removeListener(key, self)
end

function Messaging:registerMessageResponse(key, func)
	self.message_responses[key] = func
	self.message_system:addListener(key, self)
end

function Messaging:emitMessage(key, ...)
	self.message_system:emitMessage(key, ...)
end

function Messaging:receiveMessage(key, ...)

	local message_response = self.message_responses[key]
	assert(message_response, "Not listening for this message but somehow got it")
	message_response(...)

end


function Messaging:__tostring()
	return "Messaging Component" 
end
