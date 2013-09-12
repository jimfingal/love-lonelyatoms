require 'external.middleclass'

Tween = class("Tween")

function Tween:initialize(initial_value, final_value, duration, easing_func)

	self.time = 0
	
	self.initial = initial_value	
	self.final = final_value

	self.change = self.final - self.initial

	self.duration = duration

	self.func = easing_func

end

function Tween:update(dt)

	self.time = self.time + dt

	-- For all easing functions:
	-- t = elapsed time
	-- b = begin
	-- c = change == ending - beginning
	-- d = duration (total time)

	self.value = self.func(self.time, self.initial, self.change, self.duration)

	-- snap to final value
	if self.time > self.duration then
		self.value = self.final
	end

end

function Tween:getValue()
	return self.value
end




