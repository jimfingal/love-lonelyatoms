require 'external.middleclass'

InputResponse = class('InputResponse', Component)

-- Passed some update function that
function InputResponse:initialize()

	Component.initialize(self, 'InputResponse')
	
	-- Func must have signature: function(entity, held_actions, pressed_actions, dt)
	self.reponses = List()


end

function InputResponse:addResponse(func)
	self.reponses:append(func)
	return self
end

function InputResponse:responseFunctions()
	return self.reponses
end

function InputResponse:__tostring()
	return "InputResponse: [ function = " .. tostring(self.reponses) .. "]" 
end
