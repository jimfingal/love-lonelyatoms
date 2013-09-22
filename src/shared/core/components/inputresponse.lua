require 'external.middleclass'
require 'core.entity.component'

InputResponse = class('InputResponse', Component)

-- Passed some update function that
function InputResponse:initialize(...)

	Component.initialize(self, 'InputResponse')
	
	-- Func must have signature: function(entity, held_actions, pressed_actions, dt)
	self.reponses = List()

	if args then
		for _, arg in ipairs(args) do
			self:addResponse(arg)
		end
	end

end

function InputResponse:addResponse(func)
	assert(type(func) == 'function', "Argument must be a function")
	self.reponses:append(func)
	return self
end

function InputResponse:responseFunctions()
	return self.reponses
end

function InputResponse:__tostring()
	return "InputResponse: [ function = " .. tostring(self.reponses) .. "]" 
end
