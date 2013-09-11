require 'external.middleclass'
require 'engine.gameobject'
require 'engine.transform'
require 'collections.list'

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


SpriteGroup = class('SpriteGroup', Entity)

function SpriteGroup:initialize(name, visible, active)

	GameObject.initialize(self, name)

	self.visible = visible or false
	self.active = active or false

	self.sprites = List()
end


function SpriteGroup:add(sprite)
	assert(sprite, 'asked to add nil to a group')
	assert(sprite ~= self, "can't add a group to itself")
	self.sprites:append(sprite)
end

function SpriteGroup:remove(sprite)
	assert(sprite, 'asked to remove nil to a group')
	self.sprites:removeFirst(sprite)
end

function SpriteGroup:members()
	return self.sprites:members()
end

function SpriteGroup:processInput(elapsed, input)

	if not self.active then return end

	for i, sprite in self:members() do
		if sprite.active then
			sprite:processInput(elapsed, input)
		end
	end

	if self.onProcessInput then self:onProcessInput(elapsed, input) end

end

function SpriteGroup:update(elapsed)

	if not self.active then return end

	for i, sprite in self:members() do
		if sprite.active then
			sprite:update(elapsed)
		end
	end

	if self.onUpdate then self:onUpdate(elapsed) end

end

-- passes endFrame events to member sprites

function SpriteGroup:endFrame(elapsed)
	
	if not self.active then return end

	for i, sprite in self:members() do
		if sprite.active then
			sprite:endFrame(elapsed)
		end
	end

	if self.onEndFrame then self:onEndFrame(elapsed) end

end


function SpriteGroup:processCollision(other, callback)

	-- Should work whether or not other is a group
	for _, member in self:members() do
		member:processCollision(other)
	end

end



-- Method: draw
-- Draws all visible member sprites onscreen.

function SpriteGroup:draw()

	if not self.visible then return end

	for i, sprite in self:members() do
		if sprite.visible then
			sprite:draw()
		end
	end
end