
require 'external.middleclass'
require 'audio.waves'

AudioModulator = class('AudioModulator')


function AudioModulator:initialize(samples)

	self.waveform = Waves.SINE
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