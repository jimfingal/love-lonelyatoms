require 'external.middleclass'
require 'entity.system'
require 'entity.components.behavior'

SoundSystem = class('SoundSystem', System)

function SoundSystem:initialize(world)

	System.initialize(self, 'Sound System')
	self.world = world

end
