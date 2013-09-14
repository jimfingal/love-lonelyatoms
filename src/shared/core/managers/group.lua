require 'external.middleclass'
require 'core.oldentity.entity'
require 'collections.list'
require 'core.mixins.visible'


-- Class: Group
-- A group is a set of entities. Groups can be used to
-- implement layers or keep categories of entities together.

-- Event: onUpdate
-- Called once each frame, with the elapsed time since the last frame in seconds.
--
-- Event: onBeginFrame
-- Called once each frame like onUpdate, but guaranteed to fire before any others' onUpdate handlers.
--
-- Event: onEndFrame
-- Called once each frame like onUpdate, but guaranteed to fire after all others' onUpdate handlers.


-- TODO -- make into a group manager
Group = class('Group')

function Group:initialize(name)

	Entity.initialize(self)
	self.entities = List()
	self.name = name
end


function Group:add(entity)
	assert(entity, 'asked to add nil to a group')
	assert(entity ~= self, "can't add a group to itself")
	self.entities:append(entity)
end

function Group:remove(entity)
	assert(entity, 'asked to remove nil to a group')
	self.entities:removeFirst(entity)
end

function Group:members()
	return self.entities:members()
end

--[[
function Group:processInput(elapsed, input)

	if not self.active then return end

	for i, entity in self:members() do
		if entity.active then
			entity:processInput(elapsed, input)
		end
	end

	if self.onProcessInput then self:onProcessInput(elapsed, input) end

end

function Group:update(elapsed)

	if not self.active then return end

	for i, entity in self:members() do
		if entity.active then
			entity:update(elapsed)
		end
	end

	if self.onUpdate then self:onUpdate(elapsed) end

end

-- passes endFrame events to member entities

function Group:endFrame(elapsed)
	
	if not self.active then return end

	for i, entity in self:members() do
		if entity.active then
			entity:endFrame(elapsed)
		end
	end

	if self.onEndFrame then self:onEndFrame(elapsed) end

end



-- Method: draw
-- Draws all visible member entities onscreen.

function Group:draw()

	for i, entity in self:members() do
		if includes(Visible, entity.class) then
			entity:draw()
		end
	end
end

]]

