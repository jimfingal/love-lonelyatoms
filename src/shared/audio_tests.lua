require 'audio.audioengine'
require 'socket'

before = socket.gettime()
a = AudioEngine()
after = socket.gettime()
print(after - before)

print(a.sine_samples)
