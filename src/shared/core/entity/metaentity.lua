require 'external.middleclass'


MetaEntity = class('MetaEntity')

-- Fallback EM to use if one not specified; should be set once only at program-start.
MetaEntity.default_entity_manager = nil

-- Arguments: Name and components
function MetaEntity:initialize(name, ...)

	assert(default_entity_manager, "To call this constructor we must have a global entity manager")

	self.name = name
	self.parent_entity_manager = default_entity_manager
	self.uuid = default_entity_manager.createEntity()

	for _, component in ipairs(arg) do
		self:addComponent(component)
	end

end


function MetaEntity:addComponent(component)
	self.parent_entity_manager:addComponent(self.uuid, component)
end

function MetaEntity:getComponent(component_class)
	return self.parent_entity_manager:getComponent(self.uuid, component_class)
end

function MetaEntity:hasComponent(component_class)
	return self:getComponent(component_class)
end

function MetaEntity:getAllComponents()
	return self.parent_entity_manager:getAllComponentsOnEntity(self.uuid)
end

function MetaEntity:removeComponent(component_class)
	self.parent_entity_manager:removeComponent(self.uuid, component_class)
end

function MetaEntity:removeAllComponents()
	for _, component in ipairs(self:getAllComponents()) do
		self:removeComponent(component.class)
	end
end

function MetaEntity:kill()
	self.parent_entity_manager:kill(self.uuid)
end


function MetaEntity:__tostring()

	local s = ""

	for _, component in ipairs(self:getAllComponents()) do

		if string.len(s) > 0 then
			s = s .. ', '
		end

		s = s .. tostring(component)

	end

	return "Entity(".. uuid .. " :: " .. name .."),".. s
end