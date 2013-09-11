require 'external.middleclass'
require 'core.sprite'
require 'core.shapes'

Brick = class('Brick', Sprite)

local DEATH_SOUND = "death"

function Brick:initialize(x, y, width, height, r, g, b, sound)

	sprite_and_collider_shape = RectangleShape(width, height)

	Sprite.initialize(self, x, y, sprite_and_collider_shape)

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