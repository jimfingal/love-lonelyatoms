
require 'external.middleclass'

local uuid = require('external.uuid')

uuid.randomseed(os.time())

EntityManager = class('EntityManager')

function EntityManager:initialize()

	self.all_entities = {}
	self.entity_names = {}
	self.component_stores = {}

end

-- Creates a UUID and registers it to our list of entities
function EntityManager:createEntity(name)

	local uuid = uuid()

	-- Fast lookup
	self.all_entities[uuid] = true

	if name then
		self:setEntityName(uuid, name)
	end

	return uuid
end


function EntityManager:setEntityName(uuid, name)
	self.entity_names[uuid] = name
end

function EntityManager:getEntityName(uuid)
	return self.entity_names[uuid]
end


function EntityManager:getAllEntities()
	return self.all_entities
end


function EntityManager:addComponent(uuid, component)

	assert(uuid and component, "Must have a uuid and component parameter")

	local store = self.component_stores[component.class]

	if not store then
		store = {}
		self.component_stores[component.class] = store
	end

	store[uuid] = component

end


-- Used internally to validate
function EntityManager:getStoreAndComponent(uuid, component_class)

	assert(uuid and component_class, "Must have a uuid and component class parameter")

	local component = nil
	local store = self.component_stores[component_class]

	if store then 
		component = store[uuid]
	end

	return store, component

end

function EntityManager:getStoreAndComponentWithValidation(uuid, component_class)

	local store, component = self:getStoreAndComponent(uuid, component_class)

	assert(store, 'There are no entities registered with component: ' .. tostring(component_class))
	assert(component, 'There is no component of type ' .. tostring(component_class) .. ' for entity ' 
						.. uuid .. '( ' .. self:getEntityName(uuid) .. ')')

	return store, component
end


function EntityManager:getComponent(uuid, component_class)

	assert(uuid and component_class, "Must have a uuid and component class parameter")

	local store, component = self:getStoreAndComponentWithValidation(uuid, component_class)

	return component

end


function EntityManager:removeComponent(uuid, component_class)

	assert(uuid and component_class, "Must have a uuid and component class parameter")

	local store, component = self:getStoreAndComponentWithValidation(uuid, component_class)

	store[uuid] = nil

end


function EntityManager:hasComponent(uuid, component_class)

	assert(uuid and component_class, "Must have a uuid and component class parameter")

	local store, component = self:getStoreAndComponent(uuid, component_class)

	return store and component

end

function EntityManager:getAllComponentsOfType(component_class)

	assert(component_class, "Must have a component class parameter")

	local components = {}

	local store = self.component_stores[component_class]

	if store then
		for entity, component in pairs(store) do
			table.insert(components, component)
		end
	end

	return components

end


function EntityManager:getAllComponentsOnEntity(uuid)

	assert(uuid, "Must have a uuid parameter")

	local components = {}

	for class, store in pairs(self.component_stores) do

		local component = store[uuid]

		if component then
			table.insert(components, component)
		end

	end

	return components

end

function EntityManager:getAllEntitiesContainingComponent(component_class)

	assert(component_class, "Must have a component class parameter")

	local entities = {}

	local store = self.component_stores[component_class]

	if store then
		for entity, component in pairs(store) do
			table.insert(entities, entity)
		end
	end

	return entities

end

function EntityManager:killEntity(uuid)

	assert(uuid, "Must have a uuid parameter")

	for class, store in pairs(self.component_stores) do
		store[uuid] = nil
	end

	self:setEntityName(uuid, nil)
	self.all_entities[uuid] = nil

end

