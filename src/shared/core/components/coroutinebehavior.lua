require 'external.middleclass'
require 'core.entity.component'

CoroutineBehavior = class('CoroutineBehavior', Component)

-- Passed some update function that
function CoroutineBehavior:initialize()

	Component.initialize(self, 'CoroutineBehavior')
	
	self.routines = Set()

end

function CoroutineBehavior:addCoroutineFunction(func)

	local co = coroutine.create(func)
  	self.routines:add(co)
  	return co

end

function CoroutineBehavior:removeCoroutineFunction(co)
  	self.routines:remove(co)
  	return self
end

function CoroutineBehavior:getRoutines()
	return self.routines
end