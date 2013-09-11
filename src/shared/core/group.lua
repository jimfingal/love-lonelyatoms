require 'external.middleclass'
require 'core.entity'
require 'collections.list'
require 'core.mixins.visible'


-- Class: Sprite
-- A group is a set of sprites. Groups can be used to
-- implement layers or keep categories of sprites together.

-- Event: onUpdate
-- Called once each frame, with the elapsed time since the last frame in seconds.
--
-- Event: onBeginFrame
-- Called once each frame like onUpdate, but guaranteed to fire before any others' onUpdate handlers.
--
-- Event: onEndFrame
-- Called once each frame like onUpdate, but guaranteed to fire after all others' onUpdate handlers.


Group = class('Group', Entity)

function Group:initialize()

	Entity.initialize(self)
	self.sprites = List()
end


function Group:add(sprite)
	assert(sprite, 'asked to add nil to a group')
	assert(sprite ~= self, "can't add a group to itself")
	self.sprites:append(sprite)
end

function Group:remove(sprite)
	assert(sprite, 'asked to remove nil to a group')
	self.sprites:removeFirst(sprite)
end

function Group:members()
	return self.sprites:members()
end

function Group:processInput(elapsed, input)

	if not self.active then return end

	for i, sprite in self:members() do
		if sprite.active then
			sprite:processInput(elapsed, input)
		end
	end

	if self.onProcessInput then self:onProcessInput(elapsed, input) end

end

function Group:update(elapsed)

	if not self.active then return end

	for i, sprite in self:members() do
		if sprite.active then
			sprite:update(elapsed)
		end
	end

	if self.onUpdate then self:onUpdate(elapsed) end

end

-- passes endFrame events to member sprites

function Group:endFrame(elapsed)
	
	if not self.active then return end

	for i, sprite in self:members() do
		if sprite.active then
			sprite:endFrame(elapsed)
		end
	end

	if self.onEndFrame then self:onEndFrame(elapsed) end

end



-- Method: draw
-- Draws all visible member sprites onscreen.

function Group:draw()

	for i, sprite in self:members() do
		if includes(Visible, sprite.class) then
			sprite:draw()
		end
	end
end

