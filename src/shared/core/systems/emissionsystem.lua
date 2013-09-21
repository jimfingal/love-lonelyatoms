require 'external.middleclass'
require 'core.entity.system'
require 'core.components.emitter'

EmissionSystem = class('EmissionSystem', System)

function EmissionSystem:initialize(world)

	System.initialize(self, 'Emission System')
	self.world = world

end
