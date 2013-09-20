require 'external.middleclass'
require 'core.entity.system'
require 'core.components.behavior'


TimeSystem = class('TimeSystem', System)

function TimeSystem:initialize(world)

	System.initialize(self, 'Time System')
	self.world = world
	self.time = 0
	self.dt = 0
	self.dilation = 1

	self.on = true
end

function TimeSystem:update(dt)

	if self.on then
		local dilated_dt = dt * self.dilation
		self.time = self.time + dilated_dt
		self.dt = dilated_dt
	end

end

function TimeSystem:getDt()
	return self.dt + 0
end

function TimeSystem:getTime()
	return self.time + 0
end

function TimeSystem:stop()
	self.on = false
	return self
end

function TimeSystem:go()
	self.on = true
	return self
end
