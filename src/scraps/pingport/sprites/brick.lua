require 'external.middleclass'
require 'core.oldentity.shapes'

Brick = class('Brick', CollidableRectangle)

local DEATH_SOUND = "death"

function Brick:initialize(x, y, width, height, r, g, b, sound)

	CollidableRectangle.initialize(self, x, y, width, height)

	self:setColor(r, g, b)

	self.sounds = {}

	-- TODO: some sort of asset manager that functions both globally and is attached to sprites?
	if sound then
		self.sounds[DEATH_SOUND] = sound
	end
	
end

function Brick:loadDeathSound(snd)

	self.sounds[DEATH_SOUND] = snd

end

function Brick:playDeathSound()
	love.audio.play(self.sounds[DEATH_SOUND])
end