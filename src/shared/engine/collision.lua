require 'external.middleclass'
require 'collections.list'

CollisionManager = class("CollisionManager")


function CollisionManager:initialize()
	self.watched_collisions = List()
end

function CollisionManager:checkSpriteCollisions(a, b, callback)

	collisions = List()

end
