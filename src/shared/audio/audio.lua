require 'collections.list'
require 'audio.audioengine'
require 'audio.frequency'
require 'external.middleclass'

Audio = class('Audio')

function Audio:initialize(engine)

	self.engine = engine

	self.waveform = Waveform.SQUARE

	self.frequency = 440 -- Hertz
	self.amplitude = 1.0 -- Value in the range 0.0 to 1.0
	self.duration = 1.0 -- Value in seconds
	-- self.release = 0.2 -- Value in seconds

	--[[

		private var m_frequencyModulator:AudioModulator = null;
		private var m_amplitudeModulator:AudioModulator = null;
		internal var position:Number         = 0.0;
		internal var playing:Boolean         = false;
		internal var releasing:Boolean       = false;
		internal var samples:Vector.<Number> = null;

	]]
	self.samples = {}

end

function Audio:generateSamples()

	local waveform_cache = self.engine.samples[self.waveform]

	-- Samples at 44100 samples / second
	local num_samples = self.duration * 44100

	local starting_position = self.engine.sample_time + 0

	local position = starting_position

	-- Position within my samples
	for i = 0, num_samples do

		-- Position within the waveform cache
		local waveform_position = (44100 * self.frequency * position) % 44100
		local waveform_sample = waveform_cache[waveform_position]

		-- Set my sample equal to the waveform's sample plus my amplitude
		self.samples[i] = waveform_sample * self.amplitude

		position = position + self.engine.sample_time

	end

end




AudioModulator = class('AudioModulator')


function AudioModulator:initialize(samples)

	self.waveform = Waveform.SINE
	self.frequency = 4.0 -- Hertz
	self.amplitude = 1 
	self.shift = 0.0 
	self.samples = samples
end

function AudioModulator:process(time)

	local t = time + 0
	local p = 0
	local s = 0.0

	if self.shift ~= 0.0 then
		t = t + (1/self.frequency) * self.shift
	end

	p = ( 44100 * self.frequency * t ) % 44100;
    s = self.samples:memberAt(p)

    return s * self.amplitude;

end