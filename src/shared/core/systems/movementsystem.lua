require 'external.middleclass'
require 'core.entity.system'

MovementSystem = class('MovementSystem', System)

function MovementSystem:initialize()
	System.initialize(self, 'Movement System')
end
