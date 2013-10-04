
require 'external.middleclass'
require 'audio.waves'

AudioModulator = class('AudioModulator')


function AudioModulator:initialize(engine, waveform, frequency, amplitude, shift)

	self.engine = engine

	self.waveform = waveform or Waves.SINE
	self.frequency = frequency or 0.1 -- Hertz
	self.amplitude = amplitude or 0.5 
	self.shift = shift or 0.0 
	self.samples = engine.samples[self.waveform]

end

function AudioModulator:process(time)

	local t = time + 0
	local p = 0
	local s = 0.0

	if self.shift ~= 0.0 then
		t = t + (1/self.frequency) * self.shift
	end

	p = math.floor(( 44100 * self.frequency * t ) % 44100 + 1);

    s = self.samples[p]

    return s * self.amplitude;

end

function AudioModulator:__tostring()
	return "AudioModulator: Waveform " .. tostring(self.waveform) .. ", frequency " .. tostring(self.frequency) .. 
				", amplitude " .. tostring(self.amplitude) .. ", shift " .. tostring(self.shift) .. ", samples " .. tostring(self.samples)
end