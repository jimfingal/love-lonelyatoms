require 'collections.list'
require 'external.middleclass'
require 'audio.audio'
require 'audio.waves'

AudioEngine = class('AudioEngine')

function AudioEngine:initialize(sample_rate)

	-- Samples per second
	self.sample_rate = sample_rate or 44100

	-- Samples for 1 hz frequency wave for standard types
	self.samples = {}
	self.samples[Waves.SQUARE] = Waves.squareWave(self.sample_rate)
	self.samples[Waves.SAWTOOTH] = Waves.sawtoothWave(self.sample_rate)
	self.samples[Waves.SINE] = Waves.sineWave(self.sample_rate)
	self.samples[Waves.TRIANGLE] = Waves.triangleWave(self.sample_rate)

	self.sample_time = 1.0 / self.sample_rate

end

-- Create a new audio object
function AudioEngine:newAudio(waveform, duration, frequency)
	return Audio(self, waveform, duration, frequency)
end

function AudioEngine:newAudioModulator(waveform, frequency, amplitude, shift)
	return AudioModulator(self, waveform,  frequency, amplitude, shift)
end


function AudioEngine:setSamples(source, audio)
	for i = 1, #audio.samples do
		source:setSample(i, audio.samples[i])
	end
end


