require 'external.middleclass'

AudioHelper = class("AudioHelper")

function AudioHelper:initialize(max_sources)

	self.max_sources = max_sources or 3

end

function AudioHelper:stopAudio()

	-- TODO: audio handles?
	
	love.audio.stop()

end