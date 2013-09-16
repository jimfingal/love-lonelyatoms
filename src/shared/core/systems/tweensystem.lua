require 'external.middleclass'
require 'collections.list'

require 'external.middleclass'
require 'core.entity.system'
require 'core.components.transform'
require 'core.components.collider'
require 'helpers.mathhelpers'
require 'core.tween'


TweenSystem = class('TweenSystem', System)

function TweenSystem:initialize(world)

	System.initialize(self, 'Tween System')

	self.world = world
	self.registry = {}

end


-- Tweens a single value
-- target is {x = 10}
function TweenSystem:addTween(duration, ref, targets, method)

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

function TweenSystem:update(dt)

	for handle, tweens in pairs(self.registry) do

		for key, tween in pairs(tweens) do

			tween:update(dt)
			handle.reference[key] = tween.value

		end
	end
end
