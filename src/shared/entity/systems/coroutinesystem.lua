require 'external.middleclass'
require 'entity.system'
require 'collections.list'

CoroutineSystem = class('CoroutineSystem', System)

local COROUTINE_DONE_MESSAGE = "cannot resume dead coroutine"

function CoroutineSystem:initialize(world)

	System.initialize(self, 'Coroutine System')

	self.world = world

	self.routines = Set()
	self.remove_buffer = Set()

end

function CoroutineSystem:runAsCoroutine(func)

  local co = coroutine.create(func)
  self.routines:add(co)

  return co

end

function CoroutineSystem:update(entities, dt)

	self:updateGlobalRoutines(dt)

end

function CoroutineSystem:runRoutines(routine_source, dt)

	self.remove_buffer:clear()

	for co in routine_source:getRoutines():members() do

		status, message = coroutine.resume(co, dt)
		if not status then

			-- Raise any errors we encounter
			assert(message == COROUTINE_DONE_MESSAGE, "Coroutine error: [" .. tostring(message) .. "]")

			self.remove_buffer:add(co)
	    end
	end

	for co in self.remove_buffer:members() do
		routine_source:removeCoroutineFunction(co)
	end

end



function CoroutineSystem:updateGlobalRoutines(dt)

	self:runRoutines(self, dt)
	
end

function CoroutineSystem:getRoutines()
	return self.routines
end


function CoroutineSystem:removeCoroutineFunction(co)
  	self.routines:remove(co)
  	return self
end
