require 'external.middleclass'
require 'entity.component'

StateComponent = class('StateComponent', Component)

-- Passed some update function that
function StateComponent:initialize()

	Component.initialize(self, 'StateComponent')
	self.states = {}

end

function StateComponent:setState(key, value)
	self.states[key] = value
	return self
end

function StateComponent:getState(key)
	return self.states[key]
end


function StateComponent:__tostring()

	local s =  "State : ["

	for k, v in pairs(self.states) do
		s = s .. "(k= " .. tostring(k) .. "; v= " .. tostring(v) .. ") "
	end	

	s = s .. "]"
	return s
end

