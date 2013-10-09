require 'external.middleclass'
require 'entity.system'
require 'entity.components.messaging'
require 'collections.set'
MessageSystem = class('MessageSystem', System)

--[[ Simple Message Bus. Keeps track of who is listening
	 to what kind of messages, and forwards them if someone sends that message. ]] 

function MessageSystem:initialize()

	System.initialize(self, 'Message System')

	self.message_listeners = {}

end

function MessageSystem:addListener(key, listener)

	local listeners = self.message_listeners[key]
	
	if not listeners then
		listeners = Set()
		self.message_listeners[key] = listeners
	end

	listeners:add(listener)

end

function MessageSystem:removeListener(key, listener)

	local listeners = self.message_listeners[key]

	assert(listeners and listeners:contains(listener), "Listener " .. tostring(listener) .. " not currently listening for message " .. key) 

	listeners:remove(listener)

end


function MessageSystem:emitMessage(key, ...)

	local listeners = self.message_listeners[key]

	if listeners then

		for listener in listeners:members() do

			listener:receiveMessage(key, ...)

		end

	end

end