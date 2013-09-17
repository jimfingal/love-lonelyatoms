require 'external.middleclass'
require 'core.entity.system'
require 'core.components.behavior'



AnimationSystem = class('AnimationSystem', System)

function AnimationSystem:initialize(world)

	System.initialize(self, 'Animation System')
	self.world = world

end


local function getFrameIndex(frame_borders, timer)

	-- Should start out on the first frame if just starting
	if timer == 0 then
		return 1
	end

	for index, border in ipairs(frame_borders) do
		if timer <= border then
			frame_index = index - 1
			return frame_index
		end
	end

	-- If we're beyond the last border, we should be in the last position.
	return #frame_borders - 1

end

function AnimationSystem:updateAnimations(entities, dt)

	for entity in entities:members() do
	
		local entity_animation = entity:getComponent(Animation)
		self:updateAnimation(entity_animation, dt)

	end

end



function AnimationSystem:updateAnimation(animation, dt)

	if animation.status ~= Animation.PLAYING then 
		return 
	end

	animation.timer = animation.timer + dt

	animation.total_runtime = animation.total_runtime + dt


	if animation.timer >= animation.total_time then

		if animation.loop then
			animation.timer = animation.timer % animation.total_time
		else
			animation.status = Animation.PAUSED
		end
	end

	animation.position = getFrameIndex(animation.frame_borders, animation.timer)

	if animation.afterUpdate then
		animation:afterUpdate(dt)
	end

end