require 'external.middleclass'
require 'core.entity.component'

Behavior = class('Behavior', Component)

-- Passed some update function that
function Behavior:initialize()

	Component.initialize(self, 'Behavior')
	
	self.update_callbacks = List()

end

function Behavior:addUpdateFunction(update_callback)
	self.update_callbacks:append(update_callback)
	return self
end

function Behavior:getUpdateFunctions()
	return self.update_callbacks
end


function Behavior:__tostring()
	return "Behavior: [ callback = " .. tostring(self.update_callback) .. "]" 
end
