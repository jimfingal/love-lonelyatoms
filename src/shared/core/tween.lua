require 'external.middleclass'
require 'core.registry'
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

	-- Don't update after expire
	if self:finished() then
		return
	end

	self.time = self.time + dt

	-- For all easing functions:
	-- t = elapsed time
	-- b = begin
	-- c = change == ending - beginning
	-- d = duration (total time)

	self.value = self.func(self.time, self.initial, self.change, self.duration)

	-- Snap to final value in case we went past it
	if self:finished() then
		self.value = self.final
	end

end

function Tween:finished()
	return self.time >= self.duration
end



-- Singleton
local TweenerClass = class("TweenerClass")


function TweenerClass:initialize()
	self.registry = {}
end

-- Tweens a single value
-- target is {x = 10}
function TweenerClass:addTween(duration, ref, targets, method)

	-- Each value gets its own tween for clarity. Takes up more memory
	-- that probably should
	local tweens = {}

	for key, target_value in pairs(targets) do

		local t = Tween(ref[key], target_value, duration, method)
		tweens[key] = t
	end

	local handle = {reference = ref, t = tweens}

	self.registry[handle] = tweens

	return handle

end

function TweenerClass:update(dt)

	for handle, tweens in pairs(self.registry) do

		for key, tween in pairs(tweens) do

			tween:update(dt)
			handle.reference[key] = tween.value

		end
	end
end

Tweener = TweenerClass()


return Tweener
