require 'collections.list'
require 'external.middleclass'

Audio = class('Audio')

function Audio:initialize(engine, waveform, duration, frequency)

	self.engine = engine

	self.waveform = waveform

	self.frequency = frequency or 550 -- Hertz
	self.duration = duration or 1.0 -- Value in seconds

	self.amplitude = 0.5 -- Value in the range 0.0 to 1.0

	self.samples = {}

end

function Audio:generateSamples()

	self.samples = {}

	local waveform_cache = self.engine.samples[self.waveform]

	assert(waveform_cache, "Should have a waveform but don't for " .. tostring(self.waveform))

	-- Samples at 44100 samples / second
	local num_samples = self.duration * 44100

	local starting_position = 0

	local position = starting_position

	-- Position within my samples
	for i = 1, num_samples do

		-- Position within the waveform cache
		local waveform_position = math.floor((44100 * self.frequency * position) % 44100 + 1)

		local waveform_sample = waveform_cache[waveform_position]

		-- Set my sample equal to the waveform's sample plus my amplitude
		self.samples[i] = waveform_sample * self.amplitude

		position = position + self.engine.sample_time

	end

end
