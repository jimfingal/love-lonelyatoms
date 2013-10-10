require 'external.middleclass'
require 'entity.system'
require 'entity.components.behavior'


BehaviorSystem = class('BehaviorSystem', System)

local COROUTINE_DONE_MESSAGE = "cannot resume dead coroutine"

function BehaviorSystem:initialize(world)

	System.initialize(self, 'Entity Behavior System')
	
	self.world = world

	self.remove_buffer = Set()

end

function BehaviorSystem:processBehaviors(entities, dt)
	
	for entity in entities:members() do
	
		self:runUpdateFunctions(entity, dt)
		
		self:runRoutines(entity, dt)

	end

end

function BehaviorSystem:runUpdateFunctions(entity, dt)

		local entity_behavior = entity:getComponent(Behavior)

		for _, update_function in entity_behavior:getUpdateFunctions():members() do

			update_function(entity, dt)

		end
end



function BehaviorSystem:runRoutines(entity, dt)

	local entity_behavior = entity:getComponent(Behavior)

	self.remove_buffer:clear()

	for co in entity_behavior:getRoutines():members() do

		status, message = coroutine.resume(co, dt)
		if not status then

			-- Raise any errors we encounter
			assert(message == COROUTINE_DONE_MESSAGE, "Coroutine error: [" .. tostring(message) .. "]")

			self.remove_buffer:add(co)
	    end
	end

	for co in self.remove_buffer:members() do
		entity_behavior:removeRoutine(co)
	end

end
