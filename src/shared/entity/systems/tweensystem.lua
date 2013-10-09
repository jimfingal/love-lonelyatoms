require 'external.middleclass'
require 'collections.list'

require 'external.middleclass'
require 'entity.system'
require 'entity.components.transform'
require 'entity.components.collider'
require 'math.util'
require 'game.tween'


TweenSystem = class('TweenSystem', System)

function TweenSystem:initialize(world)

	System.initialize(self, 'Tween System')

	self.world = world
	self.registry = {}

end


-- Tweens a single value
-- target is {x = 10}
function TweenSystem:addTween(duration, ref, targets, method, finished_func)

	-- Each value gets its own tween for clarity. Takes up more memory
	-- that probably should
	local tweens = {}

	for key, target_value in pairs(targets) do

		local t = Tween(ref[key], target_value, duration, method)
		tweens[key] = t
	end

	local handle = {reference = ref, t = tweens, finished_func = finished_func}

	self.registry[handle] = tweens

	return handle

end

function TweenSystem:update(dt)

	-- local handles_to_remove = Set()

	for handle, tweens in pairs(self.registry) do

		local all_tweens_done = true
		for key, tween in pairs(tweens) do

			tween:update(dt)
			handle.reference[key] = tween.value

			if not tween:finished() then 
				all_tweens_done = false
			end
		end

		if all_tweens_done then
			self:finalizeHandle(handle)
		end 
	end

end

function TweenSystem:finalizeHandle(handle)
	if handle.finished_func then
		handle.finished_func()
	end
	self.registry[handle] = nil
end


function TweenSystem:__tostring()

	local s = "TweenSystem: ["

	for handle, tweens in pairs(self.registry) do
		s = s .. "(Handle: " .. tostring(handle) .. "; \n Tweens: \n" 

		for key, tween in pairs(tweens) do 
			s = s .. "     Key: " .. tostring(key) .. "; Tween: " .. tostring(tween) .. "\n" 
		end

		s = s .. ")\n "
	end
	s = s .. "]"
	return s

end

