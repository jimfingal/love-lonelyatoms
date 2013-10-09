require 'external.middleclass'
require 'collections.list'
require 'util.pool'
require 'entity.component'

Emitter = class("Emitter", Component)

function Emitter:initialize(emittable_source)
	
	Component.initialize(self, 'Emitter')

	self.on = false
	self.ready_to_emit = false

	self.emission_limit = 1
	self.object_pool = Pool(emittable_source)
end

function Emitter:setNumberOfEmissions(num)
	assert(type(num) == 'number', "Must have a number input")
	self.emitted_limit = num
	self.object_pool:setObjectLimit(num)
	return self
end


function Emitter:recycle(obj)
	self.object_pool:recycle(obj)
	return self
end

function Emitter:emit(...)
	return self.object_pool:getObject(...)
end

-- For automated or timed emitters
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


