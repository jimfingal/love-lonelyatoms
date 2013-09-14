require 'external.middleclass'

MetaEntity = class('MetaEntity')

-- Convenience Object for Entity, to be able to simulate object actions on it

function MetaEntity:initialize(entity_id, parent_entity_manager)

	assert(entity_id, "To call this constructor we must have a entity_id")
	assert(parent_entity_manager, "To call this constructor we must have a parent_entity_manager")

	self.entity_id = entity_id
	self.parent_entity_manager = parent_entity_manager
	
end

function MetaEntity:getName()
	return self.parent_entity_manager:getEntityName(self.entity_id)
end

function MetaEntity:setName()
	self.parent_entity_manager:setEntityName(self.entity_id)
	return self
end

function MetaEntity:addComponent(component)
	self.parent_entity_manager:addComponent(self.entity_id, component)
	return self
end

function MetaEntity:getComponent(component_class)
	return self.parent_entity_manager:getComponent(self.entity_id, component_class)
end

function MetaEntity:hasComponent(component_class)
	return self:getComponent(component_class)
end

function MetaEntity:getAllComponents()
	return self.parent_entity_manager:getAllComponentsOnEntity(self.entity_id)
end

function MetaEntity:removeComponent(component_class)
	self.parent_entity_manager:removeComponent(self.entity_id, component_class)
end

function MetaEntity:removeAllComponents()
	for component in self:getAllComponents():members() do
		self:removeComponent(component.class)
	end
	return self
end

function MetaEntity:kill()
	self.parent_entity_manager:kill(self.entity_id)
end


function MetaEntity:__tostring()

	local s = ""

	for component in self:getAllComponents():members() do

		if string.len(s) > 0 then
			s = s .. ', '
		end

		s = s .. tostring(component)

	end

	return "Entity(".. self.entity_id .. " :: " .. tostring(self:getName()) ..") Components: [".. s .. "]"
end