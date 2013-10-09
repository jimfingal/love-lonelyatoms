require 'external.middleclass'
require 'entity.component'

SoundComponent = class('SoundComponent', Component)

-- Passed some update function that
function SoundComponent:initialize()

	Component.initialize(self, 'SoundComponent')
	self.sounds = {}
	return self

end

function SoundComponent:addSound(key, sound)
	self.sounds[key] = sound
	return self
end

function SoundComponent:getSound(key)
	return self.sounds[key]
end


function SoundComponent:__tostring()
	return "Sound Component: [ sounds = " .. tostring(self.sounds) .. "]" 
end

