
Easing = require 'external.easing'



function fadeTextInAndOut(world, rendering, fadeIn, remain, fadeOut)

    local tween_system = world:getTweenSystem()

	local fadeOut = function() 
	    tween_system:addTween(fadeOut, rendering.color, {alpha = 0}, Easing.linear)
	end

    -- Minor hack, tweening from 255 to 255
 	local wait = function() 
	    tween_system:addTween(remain, rendering.color, {alpha = 255}, Easing.linear, fadeOut)
	end

    tween_system:addTween(fadeIn, rendering.color, {alpha = 255}, Easing.linear, wait)

end
