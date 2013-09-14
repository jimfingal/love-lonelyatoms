require 'core.entity.entitymanager'
require 'core.entity.component'
require 'core.entity.metaentity'
require 'external.middleclass'

local em = EntityManager()


-- [[ Entity Manager ]]

-- Test: Create Entity
local entity_name = 'Foo!'
local entity = em:createEntity(entity_name)

local meta_entity = em:getMetaEntity(entity)

assert(entity, "We should get back a uuid from createEntity")

print(entity)
print(meta_entity)

-- Test: getEntityName

local retrieved_name = em:getEntityName(entity)
print(retrieved_name)
assert(retrieved_name == entity_name, "We should get back the name we set")
print(meta_entity)


-- Test: setEntityName

local entity_name2 = 'Bar!'

em:setEntityName(entity, entity_name2)
retrieved_name = em:getEntityName(entity)
print(retrieved_name)
assert(retrieved_name == entity_name2, "We should get back the new name we set")
print(meta_entity)

-- addComponent, getComponent
local dummy_component = Component("Dummy Component")

print("Adding dummy component to manager and validating we can get it back")
em:addComponent(entity, dummy_component)

local retrieved_component = em:getComponent(entity, dummy_component.class)

print(retrieved_component)
assert(dummy_component == retrieved_component, "Component we got back should be the same as the one we stored")

-- hasComponent

print("Validating our manager tells us we can get our component back")

assert(em:hasComponent(entity, dummy_component.class), "HasComponent should give us accurate answer")

-- getAllComponentsOfType

print("Validating we get back our component when we ask for all components of its type")

local stored_components = em:getAllComponentsOfType(dummy_component.class)

assert(stored_components:contains(dummy_component), "We should get our dummy component back as first item in list")

-- getAllComponentsOnEntity

print("Validating we get back our component when we ask for all components on entity")

local entity_components = em:getAllComponentsOnEntity(entity)

assert(entity_components:contains(dummy_component), "We should get our dummy component back as first item in list")

-- getAllEntitiesContainingComponent

print("Validating we get back our entity when we ask for all entities containing component class")

local entities = em:getAllEntitiesContainingComponent(dummy_component.class)

assert(entities:contains(entity), "We should get our entity back as first item in list")

-- removeComponent

print("Validating once we remove this component that it is no longer stored")

em:removeComponent(entity, dummy_component.class)

assert(not em:hasComponent(entity, dummy_component.class), "Should not show up that we have this component")
assert(em:getAllComponentsOfType(dummy_component.class):size() == 0, "Component shoud no longer be in store")
assert(em:getAllComponentsOnEntity(entity):size() == 0, "No components should be on entity")
assert(em:getAllEntitiesContainingComponent(dummy_component.class):size() == 0, "No entities should have this component")

			
-- Dummy Component 2

print("Validating our ability to do intersection on components")

local DummyComponentClass2 = class("Dummy Component 2", Component)
local dummy_component2 = DummyComponentClass2("DC2")

local entity2 = em:createEntity(entity_name)


em:addComponent(entity, dummy_component)
em:addComponent(entity, dummy_component2)

print(meta_entity)

em:addComponent(entity2, dummy_component)

local shared_entries = em:getAllEntitiesContainingComponents(dummy_component.class, dummy_component2.class)
assert(shared_entries:contains(entity), "Should contain the first entity")
assert(shared_entries:contains(entity2), "Should not contain the second entity")


-- killEntity
print("Validating once we kill entity it is removed from everything")
em:addComponent(entity, dummy_component)
em:killEntity(entity)

assert(not em:hasComponent(entity, dummy_component.class), "Should not show up that we have this component")
assert(em:getAllComponentsOfType(dummy_component.class):size() == 0, "Component shoud no longer be in store")
assert(em:getAllComponentsOnEntity(entity):size() == 0, "No components should be on entity")
assert(em:getAllEntitiesContainingComponent(dummy_component.class):size() == 0, "No entities should have this component")
assert(not em:getEntityName(entity), "Entity should no longer have a stored name")
assert(em:getAllEntities():size() == 0, "Entity should not be in all entity table")