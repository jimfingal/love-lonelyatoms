require 'external.middleclass'
require 'entity.component'
require 'collections.list'

History = class('History', Component)

function History:initialize()

	Component.initialize(self, 'History')

	self.frames_tracked = 10
	self.component_history = {}
end

function History:setFramesTracked(size)

	self.frames_tracked = size
	return self

end

function History:trackComponent(component_class)

	assert(component_class.snapshot, "Component must implement 'snapshot' function to be tracked")

	if not self.component_history[component_class] then
		self.component_history[component_class] = List()
	end

	return self
end

function History:getTrackedComponents()

	local component_classes = Set()

	for component_class, _ in pairs(self.component_history) do
		component_classes:add(component_class)
	end

	return component_classes

end

function History:getComponentHistory(component_class)
	assert(self.component_history[component_class], "Not tracking component history for " .. tostring(component_class))
	return self.component_history[component_class] 
end


function History:recordFrame(component)

	local class = component.class

	local previous = self:getComponentHistory(class)

	local discarded = nil
	if previous:size() >= self.frames_tracked then
		discarded = previous:popLeft()
	end

	previous:append(component:snapshot(discarded))

end

function History:clear()
	for component in self:getTrackedComponents():members() do
		self.component_history[component] = List()
	end
end


function History:__tostring()
	local s =  "History, tracking : ["

	for c in self:getTrackedComponents():members() do

		s = s .. "Component (" .. tostring(c) .. ") : "

		local i = 1
		for _, frame in self:getComponentHistory(c):members() do
			s = s .. "Frame " .. i .. ": "
			s = s .. tostring(frame) .. "; "
			i = i + 1
		end

	end

	s = s .. "]" 

	return s
end
