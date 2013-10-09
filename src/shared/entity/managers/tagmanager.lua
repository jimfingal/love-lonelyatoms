require 'external.middleclass'

TagManager = class('TagManager')

function TagManager:initialize(world)
        self.entities_by_tag = {}
        self.world = world
end

function TagManager:register(tag, entity)
		assert(tag, "Must be given a tag input: " .. tostring(tag))
		assert(entity, "Must be given an entity input: " .. tostring(entity))
        self.entities_by_tag[tag] = entity
end

function TagManager:getEntity(tag)
		assert(tag, "Must be given a tag input: " .. tostring(tag))
        return self.entities_by_tag[tag]
end

