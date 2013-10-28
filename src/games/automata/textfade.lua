
Easing = require 'external.easing'



function fadeTextInAndOut(entity, fadeIn, remain, fadeOut)

    local tween_system = entity:getWorld():getTweenSystem()
    local rendering = entity:getComponent(Rendering):getRenderable()

	local fadeOut = function() 
	    tween_system:addTween(fadeOut, rendering.color, {alpha = 0}, Easing.linear)
	end

    -- Minor hack, tweening from 255 to 255
 	local wait = function() 
	    tween_system:addTween(remain, rendering.color, {alpha = 255}, Easing.linear, fadeOut)
	end

    tween_system:addTween(fadeIn, rendering.color, {alpha = 255}, Easing.linear, wait)

end
