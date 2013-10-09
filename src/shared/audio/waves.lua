require 'collections.list'
require 'math.util'

Waves = {}

Waves.SQUARE = 1
Waves.SAWTOOTH = 2
Waves.SINE = 3
Waves.TRIANGLE = 4

function Waves.squareWave(values)
	
	local sample_list = {}
 	local waveform_position = nil

 	for i = 0, values - 1 do

		local insert_value = nil
 		
 		waveform_position = i / values

 		if waveform_position < 0.5 then
 			insert_value = 1
 		else
 			insert_value = -1
 		end

 		sample_list[i + 1] = insert_value
 	end

 	return sample_list
end

-- Samples from -1 to 1
function Waves.sawtoothWave(values)

	local sample_list = {}
 	local waveform_position = nil

 	for i = 0, values - 1 do

		local insert_value = nil
 		
 		waveform_position = i / values

 		if waveform_position < 0.5 then
 			insert_value = waveform_position * 2
 		else
 			insert_value = waveform_position * 2 - 2
 		end

 		sample_list[i + 1] = insert_value
 	end

 	return sample_list
end

-- Samples from -1 to 1
function Waves.sineWave(values)

	local sample_list = {}
 	local waveform_position = nil
 	local insert_value = nil

 	for i = 0, values - 1 do

 		waveform_position = i / values
		insert_value = math.sin(waveform_position * 2.0 * math.pi )
 		sample_list[i + 1] = insert_value
 	end

 	return sample_list
end

-- Samples from -1 to 1
function Waves.triangleWave(values)

	local sample_list = {}
 	local waveform_position = nil
 	local insert_value = nil

 	for i = 0, values - 1 do

 		waveform_position = i / values

 		if waveform_position < 0.25 then
 			insert_value = waveform_position * 4
 		elseif waveform_position < 0.75 then
 			insert_value = 2 - waveform_position * 4
 		else
 			insert_value = waveform_position * 4 - 4
 		end

 		sample_list[i + 1] = insert_value
 	end

 	return sample_list
end
