require 'external.middleclass'


-- Base Interface for System.
-- Systems have:
--		- Human readable name
--		- Interface to update a tick
System = class('System')

function System:initialize(name)
	self.name = name
end

function System:__tostring()
	return "System: " .. tostring(self.name)
end