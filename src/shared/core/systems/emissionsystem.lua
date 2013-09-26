require 'external.middleclass'
require 'core.entity.system'
require 'core.components.emitter'

EmissionSystem = class('EmissionSystem', System)

function EmissionSystem:initialize(world)

	System.initialize(self, 'Emission System')
	self.world = world

end


function EmissionSystem:updateEmitters(entities)

	for entity in entities:members() do

		local emitter = entity:getComponent(Emitter)

		if emitter:isActive() and emitter:isReady() then

			self:processEmission(emitter)

		end

	end

end


function EmissionSystem:processEmission(emitter)

	local this_guy = emitter:emit()

end