require 'external.middleclass'
require 'collections.list'


Tween = class("Tween")

function Tween:initialize(initial_value, final_value, duration, easing_func)

	self.time = 0

	self.initial = initial_value	
	self.final = final_value

	self.change = self.final - self.initial

	self.duration = duration

	self.func = easing_func

	self.value = self.initial_value

end

function Tween:update(dt)

	if self:finished() then
		return
	end

	self.time = self.time + dt

	-- Snap to final value in case we went past it

	-- For all easing functions:
	-- t = elapsed time
	-- b = begin
	-- c = change == ending - beginning
	-- d = duration (total time)

	if self:finished() then
		self.value = self.final
	else 
		self.value = self.func(self.time, self.initial, self.change, self.duration)
	end

end

function Tween:finished()
	return self.time >= self.duration
end


