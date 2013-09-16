require 'external.middleclass'
require 'core.entity.system'
require 'core.components.behavior'

SoundSystem = class('SoundSystem', System)

function SoundSystem:initialize(world)

	System.initialize(self, 'Sound System')
	self.world = world

end
