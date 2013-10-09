require 'external.middleclass'
require 'core.entity.system'
require 'collections.list'

CoroutineSystem = class('CoroutineSystem', System)

local coroutine_done_message = "cannot resume dead coroutine"

function CoroutineSystem:initialize(world)

	System.initialize(self, 'Coroutine System')

	self.world = world

	self.routines = Set()
	self.to_remove = Set()

end

function CoroutineSystem:runAsCoroutine(func)

  local co = coroutine.create(func)
  self.routines:add(co)

  return co

end



function CoroutineSystem:update(dt)


	self.to_remove:clear()

	for co in self.routines:members() do

		status, message = coroutine.resume(co, dt)
		if not status then

			assert(message == coroutine_done_message, "Coroutine error: [" .. tostring(message) .. "]")

			self.to_remove:add(co)
	    end
	end

	for co in self.to_remove:members() do
		self.routines:remove(co)
	end

end
