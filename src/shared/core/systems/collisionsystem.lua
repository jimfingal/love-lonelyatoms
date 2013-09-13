require 'external.middleclass'
require 'core.entity.system'

CollisionSystem = class('CollisionSystem', System)

function CollisionSystem:initialize()

	System.initialize(self, 'Collision System')

end