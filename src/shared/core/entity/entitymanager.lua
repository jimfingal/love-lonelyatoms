
require 'external.middleclass'
require 'collections.set'
require 'collections.multimap'
require 'core.entity.metaentity'


local uuid = require('external.uuid')

uuid.randomseed(os.time())

EntityManager = class('EntityManager')

function EntityManager:initialize(world)

	self.all_entities = {}
	self.entity_names = {}
	self.component_stores = {}
	self.world = world
	self.query_cache = {}
	
end

-- Creates a UUID and registers it to our list of entities
function EntityManager:createEntity(name)

	local uuid = uuid()

	local entity = MetaEntity(uuid, self.world)

	-- Fast lookup
	self.all_entities[uuid] = entity

	if name then
		self:setEntityName(uuid, name)
	end

	return entity
end


function EntityManager:setEntityName(uuid, name)
	self.entity_names[uuid] = name
end

function EntityManager:getEntityName(uuid)

	local name = self.entity_names[uuid]
	return name or "" 
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
						.. tostring(uuid) .. '( ' .. self:getEntityName(uuid) .. ')')

	return store, component
end


function EntityManager:getComponent(uuid, component_class)

	assert(uuid and component_class, "Must have a uuid and component class parameter; given: " .. tostring(uuid) .. " and " .. tostring(component_class))

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

	local components = Set()

	local store = self.component_stores[component_class]

	if store then
		for uuid, component in pairs(store) do
			components:add(component)
		end
	end

	return components

end


function EntityManager:getAllComponentsOnEntity(uuid)

	assert(uuid, "Must have a uuid parameter")

	local components = Set()

	for class, store in pairs(self.component_stores) do

		local component = store[uuid]

		if component then
			components:add(component)
		end

	end

	return components

end

-- Returns a set of all entities containing a particular component
function EntityManager:getAllEntitiesContainingComponent(component_class)

	assert(component_class, "Must have a component class parameter")

	local entities = Set()

	local store = self.component_stores[component_class]

	if store then
		for uuid, component in pairs(store) do
			entities:add(self.all_entities[uuid])
		end
	end

	return entities

end

-- Otherwise, we use a query
function EntityManager:query(entity_query)

	--[[
	if self.query_cache[entity_query] then
		return self.query_cache[entity_query]
	end
	--]]

	local anded_entities = Set()

	local first = true

	for i, or_set in  entity_query:getQuery():members() do

		local or_entities = Set()

		for component in or_set:members() do
			local e = self:getAllEntitiesContainingComponent(component)
			or_entities:addSet(e)
		end

		if first then
			anded_entities:addSet(or_entities)
			first = false
		else

			anded_entities = Set.intersection(anded_entities, or_entities)

			if anded_entities:size() == 0 then
				return anded_entities
			end
		end
	end

	-- self.query_cache[entity_query] = anded_entities
	
	return anded_entities

end




function EntityManager:killEntity(uuid)

	assert(uuid, "Must have a uuid parameter")

	for class, store in pairs(self.component_stores) do
		store[uuid] = nil
	end

	self:setEntityName(uuid, nil)
	self.all_entities[uuid] = nil

end

