require 'audio.audioengine'
require 'socket'

before = socket.gettime()
local engine = AudioEngine()
after = socket.gettime()
print(after - before)


print("Checking samples are full")
assert(#engine.samples[Waves.SINE] == engine.sample_rate, "Should have a number of samples equal to the sample rate, instead... " .. tostring(#engine.samples[Waves.SINE]))

for i = 1, #engine.samples[Waves.SINE] do
	assert(engine.samples[Waves.SINE][i], "Every value should be filled but this index is not filled: " .. tostring(i))
end


print("Creating new audio file")
local audio = engine:newAudio(Waves.SINE)

assert(audio.waveform == Waves.SINE, "Should have right waveform")
assert(audio.duration, "Should have a duration")
assert(audio.frequency, "Should have a frequency")
assert(audio.amplitude, "Should have a amplitude")


print("Generating samples")
before = socket.gettime()
audio:generateSamples()
after = socket.gettime()
print("Took: " .. after - before)
