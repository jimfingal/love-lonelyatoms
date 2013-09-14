require 'external.middleclass'

TagManager = class('TagManager')

function TagManager:initialize(world)
        self.entities_by_tag = {}
        self.world = world
end

function TagManager:register(tag, entity)
        self.entities_by_tag[tag] = entity
end

function TagManager:getEntity(tag)
        return self.entities_by_tag[tag]
end
