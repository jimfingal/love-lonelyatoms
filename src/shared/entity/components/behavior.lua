require 'external.middleclass'
require 'entity.component'

Behavior = class('Behavior', Component)

-- Passed some update function that
function Behavior:initialize()

	Component.initialize(self, 'Behavior')
	
	self.update_callbacks = List()

	self.routines = Set()

end

function Behavior:addUpdateFunction(update_callback)
	self.update_callbacks:append(update_callback)
	return self
end

function Behavior:getUpdateFunctions()
	return self.update_callbacks
end


function Behavior:addRoutine(func)

	local co = coroutine.create(func)
  	self.routines:add(co)
  	return co

end

function Behavior:removeRoutine(co)
  	self.routines:remove(co)
  	return self
end

function Behavior:getRoutines()
	return self.routines
end


function Behavior:__tostring()
	return "Behavior: [ callback = " .. tostring(self.update_callback) .. "]" 
end
