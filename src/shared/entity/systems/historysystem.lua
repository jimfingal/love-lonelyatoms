require 'external.middleclass'
require 'entity.system'
require 'entity.components.history'


HistorySystem = class('HistorySystem', System)

function HistorySystem:initialize(world)

	System.initialize(self, 'Entity history tracking system')
	self.world = world
	self.frame_number = 0
	self.record_every_N_frame = 60

end

function HistorySystem:setFrameInterval(n)
	self.record_every_N_frame = n
end

function HistorySystem:snapshotHistories(entities)

	self.frame_number = self.frame_number + 1

	if self.frame_number % self.record_every_N_frame == 0 then
	
	  for entity in entities:members() do
  	  		
	  		local history = entity:getComponent(History)

	  		for component_class, _ in pairs(history.component_history) do
	  			local value = entity:getComponent(component_class)
	  			history:recordFrame(value)
	  		end  
			

	  end
	end

end
