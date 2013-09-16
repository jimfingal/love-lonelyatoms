require 'external.middleclass'
require 'core.entity.system'
require 'core.components.behavior'


BehaviorSystem = class('BehaviorSystem', System)

function BehaviorSystem:initialize(world)

	System.initialize(self, 'Entity Behavior System')
	self.world = world

end

function BehaviorSystem:processBehaviors(entities, dt)
	
	for entity in entities:members() do
	
		local entity_behavior = entity:getComponent(Behavior)

		for _, update_function in entity_behavior:getUpdateFunctions():members() do

			update_function(entity, dt)

		end

	end

end
