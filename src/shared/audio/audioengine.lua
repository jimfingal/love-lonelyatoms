require 'collections.list'
require 'audio.waves'
require 'audio.samples'
require 'external.middleclass'


Waveform = {}

Waveform.SQUARE = 1
Waveform.SAWTOOTH = 2
Waveform.SINE = 3
Waveform.TRIANGLE = 4


AudioEngine = class('AudioEngine')

function AudioEngine:initialize(sample_rate)

	self.sample_rate = sample_rate

	self.samples = {}
	self.samples[Waveform.SQUARE] = squareWave(self.sample_rate)
	self.samples[Waveform.SAWTOOTH] = sawtoothWave(self.sample_rate)
	self.samples[Waveform.SINE] = sineWave(self.sample_rate)
	self.samples[Waveform.TRIANGLE] = triangleWave(self.sample_rate)

	self.sample_time = 1.0 / self.sample_rate

	self.buffer_size = 2048
--[[

static private const BUFFER_SIZE:int    = 2048;
static private const SAMPLE_TIME:Number = 1.0 / 44100.0;
]]

end


function AudioEngine:getAudio(waveform)

	return Audio(self)

end




-- Samples from -1 to 1
local squareWave = function(values)
	
	local sample_list = {}
 	local waveform_position = nil

 	for i = 0, values do

		local insert_value = nil
 		
 		waveform_position = i / values

 		if waveform_position < 0.5 then
 			insert_value = 1
 		else
 			insert_value = -1
 		end

 		sample_list[i] = insert_value
 	end

 	return sample_list
end

-- Samples from -1 to 1
local sawtoothWave = function(values)

	local sample_list = {}
 	local waveform_position = nil

 	for i = 0, values do

		local insert_value = nil
 		
 		waveform_position = i / values

 		if waveform_position < 0.5 then
 			insert_value = waveform_position * 2
 		else
 			insert_value = waveform_position * 2 - 2
 		end

 		sample_list[i] = insert_value
 	end

 	return sample_list
end

-- Samples from -1 to 1
local sineWave = function(values)

	local sample_list = {}
 	local waveform_position = nil
 	local insert_value = nil

 	for i = 0, values do

 		waveform_position = i / values
		insert_value = math.sin(waveform_position * 2.0 * math.pi )
 		sample_list[i] = insert_value
 	end

 	return sample_list
end

-- Samples from -1 to 1
local triangleWave = function(values)

	local sample_list = {}
 	local waveform_position = nil
 	local insert_value = nil

 	for i = 0, values do

 		waveform_position = i / values

 		if waveform_position < 0.25 then
 			insert_value = waveform_position * 4
 		elseif waveform_position < 0.75 then
 			insert_value = 2 - waveform_position * 4
 		else
 			insert_value = waveform_position * 4 - 4
 		end

 		sample_list[i] = insert_value
 	end

 	return sample_list
end