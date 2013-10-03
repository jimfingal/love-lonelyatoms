require 'collections.list'
require 'utils.mathutils'

-- http://gamedev.tutsplus.com/tutorials/implementation/noise-creating-a-synthesizer-for-retro-sound-effects-introduction/

--[[

1
f = Math.pow( 2, n / 12 ) * 440.0;
The n variable in that code is the number of notes from A4 (middle A) to the note we are interested in. For example, to find the frequency of A5, one octave above A4, we would set the value of n to 12 because A5 is 12 notes above A4. To find the frequency of E2 we would set the value of n to -5 because E2 is 5 notes below A4. We can also do the reverse and find a note (relative to A4) for a given frequency:
?
1
n = Math.round( 12.0 * Math.log( f / 440.0 ) * Math.LOG2E );
The reason why these calculations work is because note frequencies are logarithmic – multiplying a frequency by two moves a note up a single octave, while dividing a frequency by two moves a note down a single octave.


]]

local LOG2E = math.log10(math.exp(1))/math.log10(2)

function frequencyFromNote(n)
	return math.pow(2, n / 12) * 440.0
end


function noteFromFrequency(f)
	return math.round(12 * math.log(f / 440.0) * LOG2E, 0)
end