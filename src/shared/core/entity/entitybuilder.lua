-- Helper class that provides common pattern for building complex entities

require 'external.middleclass'

EntityBuilder  = class('EntityBuilder')

function EntityBuilder:initialize(world, name)

	self.world = world
	self.name = name
	self.entity = nil


end

-- Used to create the entity for the first time
function EntityBuilder:create()

	-- Called if we're just building one entity
	if not self.entity then
		local em = self.world:getEntityManager()
    	self.entity = em:createEntity(name)
    end

end


-- Used to reset the entity -- on game over, etc.
function EntityBuilder:reset()

end