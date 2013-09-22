require 'external.middleclass'

EntityInitializer  = class('EntityInitializer')

function EntityInitializer:initialize(world, name)

	self.world = world
	self.name = name

	local em = world:getEntityManager()
    self.entity = em:createEntity(name)

end

function EntityInitializer:addSelfToGroup(group)

	self.world:addEntityToGroup(group, self.entity)

end

function EntityInitializer:tagSelf(tag)

    self.world:tagEntity(tag, self.entity)

end