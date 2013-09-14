require 'external.middleclass'
require 'core.entity.entitymanager'

World = class('World')


function World:initialize()
	self.entity_manager = EntityManager(self)
	self.systems = {}

end

function World:getEntityManager()
	return self.entity_manager
end

function World:setSystem(system)
	self.systems[system.class] = system
end

function World:getSystem(system_class)
	return self.systems[system_class]
end