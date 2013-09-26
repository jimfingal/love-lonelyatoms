require 'core.systems.messagesystem'
require 'core.components.messaging'
require 'core.components.history'
require 'core.components.transform'

-- messageTests()


function historyTests()

	local h = History()

	print("Setting frames tracked to 5")
	h:setFramesTracked(5)
	assert(h.frames_tracked == 5, "Setter should work")

	print("telling history to track Transform")
	h:trackComponent(Transform)
	assert(h.component_history[Transform], "Transform should now be a key in the component history" )

	print("Grabbing set of tracked components")
	local s = h:getTrackedComponents()
	assert(s:contains(Transform), "Set should contain Transform")

	print("Creating new Transform")
	local t = Transform(0, 0)

	print("Recording frame")
	h:recordFrame(t)

	print("Moving transform")
	t:moveTo(5, 5)

	print("Recording frame")
	h:recordFrame(t)

	print(h)

	print("Clearing history")
	h:clear()

	print(h)

end

historyTests()



function messageTests()
	Messages = {}

	Messages.TEST_MESSAGE = "test"

	local ms = MessageSystem()


	local messenger_one = Messaging(ms)

	local messenger_two = Messaging(ms)


	messenger_one:registerMessageResponse(Messages.TEST_MESSAGE, 
											function (receiver)
												print("I am messenger one and received a message from " .. receiver)
											end)

	print("Validating that the messenger one is registered against the test message")
	assert(ms.message_listeners[Messages.TEST_MESSAGE]:contains(messenger_one), "Message System should register the listener")

	print("Validating that the messenger one has a registered callback")
	assert(messenger_one.message_responses[Messages.TEST_MESSAGE], "Messenger should have registered callback")


	messenger_two:registerMessageResponse(Messages.TEST_MESSAGE, 
											function (receiver)
												print("I am messenger two and received a message from " .. receiver)
											end)

	print("Validating that the messenger two is registered against the test message")
	assert(ms.message_listeners[Messages.TEST_MESSAGE]:contains(messenger_two), "Message System should register the listener")

	print("Validating that the messenger two has a registered callback")
	assert(messenger_two.message_responses[Messages.TEST_MESSAGE], "Messenger should have registered callback")

	print("Emitting a message from messenger one")
	messenger_one:emitMessage(Messages.TEST_MESSAGE, "Messenger One")

	print("Emitting a message from messenger two")
	messenger_two:emitMessage(Messages.TEST_MESSAGE, "Messenger Two")

	print("Stopping one listening to message")

	messenger_one:stopListeningTo(Messages.TEST_MESSAGE)

	print("Emitting a message from messenger two")
	messenger_two:emitMessage(Messages.TEST_MESSAGE, "Messenger Two")
end

