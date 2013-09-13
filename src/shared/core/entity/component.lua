require 'external.middleclass'


-- Base Interface for Component. Nothing really in common.
Component = class('Component')

function Component:initialize(name)
	self.name = name
end


function Component:__tostring()
	return "Component: " .. self.name
end