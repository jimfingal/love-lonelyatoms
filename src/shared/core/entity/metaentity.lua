require 'external.middleclass'

MetaEntity = class('MetaEntity')

-- Convenience Object for Entity, to be able to simulate object actions on it
function MetaEntity:initialize(entity_id, world)

	assert(entity_id, "To call this constructor we must have a entity_id")
	assert(world, "Must be associated with a world")

	self.entity_id = entity_id
	self.world = world
	self.parent_entity_manager = world:getEntityManager()
	
end

function MetaEntity:getId()
	return self.entity_id
end

function MetaEntity:getName()
	return self.parent_entity_manager:getEntityName(self.entity_id)
end

function MetaEntity:setName()
	self.parent_entity_manager:setEntityName(self.entity_id)
	return self
end

function MetaEntity:getWorld()
	return self.world
end

function MetaEntity:addComponent(component)
	self.parent_entity_manager:addComponent(self.entity_id, component)
	return self
end

function MetaEntity:getComponent(component_class)
	return self.parent_entity_manager:getComponent(self.entity_id, component_class)
end

function MetaEntity:hasComponent(component_class)
	return self.parent_entity_manager:hasComponent(self.entity_id, component_class)
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

function MetaEntity:addToGroup(group)
	self.world:addEntityToGroup(group, self)
end

function MetaEntity:tag(tag)
    self.world:tagEntity(tag, self)
end


function MetaEntity:kill()
	self.world:killEntity(self)
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