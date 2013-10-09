
require 'external.middleclass'
require 'audio.waves'
require 'util.counters'

local AudioProcessor = class('AudioProcessor')


function AudioProcessor:initialize()
	self.enabled = false
end

function AudioProcessor:process(samples)
	--
end


AudioDelay = class("AudioDelay", AudioProcessor)

function AudioDelay:initialize(delay_time)
	AudioProcessor.initialize(self)

	self.delay_time = delay_time
	
	self.buffer = {} -- Circular buffer for adding to audio
	self.buffer_size = math.floor( 44100 * self.delay_time ) -- Buffer state variable
	self.buffer_index = CircularCounter(self.buffer_size, 1) -- Buffer state variable

	self.gain = 0.8 -- Scale audio so doesn't make too much louder


end

function AudioDelay:process(samples)

	local v = 0

	for i = 1, #samples do

		-- Grab what's in buffer
		v = self.buffer[self.buffer_index:value()]
		if not v then
			v = 0
		end

		-- Apply gain and add the current sample
		v = v * self.gain
		v = v + samples[i]

		samples[i] = v

		-- Store back into buffer
		self.buffer_index:increment()
		self.buffer[self.buffer_index:value()] = v


	end

end



local AudioFade = class("AudioFade", AudioProcessor)

function AudioFade:initialize(easing_function)

	AudioProcessor.initialize(self)

	self.easing = easing_function

	self.b = 1
	self.c = 0

end

function AudioFade:process(samples)

	-- t = elapsed time
	-- b = begin
	-- c = change == ending - beginning
	-- d = duration (total time)

	local d = #samples
	
	for t = 1, d do

		local gain = self.easing(t, self.b, self.c, d)

		local scaled = samples[t]

		scaled = scaled * gain

		samples[t] = scaled

	end

end

FadeOut = class('FadeOut', AudioFade)

function FadeOut:initialize(easing_function)

	AudioFade.initialize(self, easing_function)
	self.b = 1
	self.c = -1
end


FadeIn = class('FadeOut', AudioFade)

function FadeIn:initialize(easing_function)

	AudioFade.initialize(self, easing_function)
	self.b = 0
	self.c = 1
end

