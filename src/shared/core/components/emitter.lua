require 'external.middleclass'
require 'collections.list'
require 'utils.pool'

Emitter = class("Emitter", Component)

function Emitter:initialize()
	
	Component.initialize(self, 'Emitter')

	self.on = false
	self.ready_to_emit = false

	self.emission_life = math.huge

	self.emission_limit = 1
	self.emmision_function = nil
	self.reset_function = nil
	self.recycle_function = nil

	self.object_pool = Pool()

	-- TODO: pool of objects?
end

function Emitter:setEmissionLife(num)
	assert(type(num) == 'number', "Must have a number input")
	self.emission_life = num
	return self

end

function Emitter:setNumberOfEmissions(num)
	assert(type(num) == 'number', "Must have a number input")
	self.emitted_limit = num
	self.object_pool:setObjectLimit(num)
	return self
end

function Emitter:setEmissionFunction(func)
	assert(type(func) == 'function', "Must be given a function")
	self.emmision_function = func
	self.object_pool:setObjectCreationFunction(func)
	return self

end

function Emitter:setRecycleFunction(func)
	assert(type(func) == 'function', "Must be given a function")
	self.recycle_function = func
	return self
end

function Emitter:setResetFunction(func)
	assert(type(func) == 'function', "Must be given a function")
	self.reset_function = func
	self.object_pool:setObjectResetFunction(func)
	return self
end

function Emitter:recycle(obj)
	if self.recycle_function then
		self.recycle_function(obj)
	end
	self.object_pool:recycle(obj)
	return self
end
function Emitter:emit()
	return self.object_pool:getObject()
end

function Emitter:isActive()
	return self.on
end

function Emitter:isReady()
	return self.ready_to_emit
end

function Emitter:makeReady()
	self.ready_to_emit = true
end

function Emitter:makeUnready()
	self.ready_to_emit = false
end

function Emitter:start()
	self.on = true
end

function Emitter:stop()
	self.on = false
end


