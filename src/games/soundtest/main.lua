require 'audio.waves'
require 'audio.samples'
require 'audio.frequency'

function love.load()

    local len = 2
    local rate = 44100
    local bits = 16
    local channel = 1

    soundData = love.sound.newSoundData(len*rate,rate,bits,channel)

    local osc = Oscillator(440, rate)
    amplitude = 0.2

    local samples = squareWave(len*rate)

    setSamples(soundData, samples)


    source = love.audio.newSource(soundData)
    love.audio.play(source)
   
end


function Oscillator(freq, rate)
    local phase = 0
    return function()
        phase = phase + 2*math.pi/rate            
        if phase >= 2*math.pi then
            phase = phase - 2*math.pi
        end 
        return math.sin(freq*phase)
    end
end


-- Perform computations, etc. between screen refreshes.
function love.update(dt)

   

end

-- Update the screen.

function love.draw()

   

end


-- function creating a sine wave sample:
function sampleSine(freq, duration, sampleRate)
    local data = { }
    for i = 1,duration*sampleRate do
        data[i] = math.sin( (i*freq/sampleRate)*math.pi*2)
    end
    return proAudio.sampleFromMemory(data, sampleRate)
end

-- plays a sample shifted by a number of halftones for a definable period of time
function playNote(len, rate, bits, channel, sample, pitch)
    love.sound.newSoundData(len*rate,rate,bits,channel)

    local scale = 2^(pitch/12)
    local sound = proAudio.soundLoop(sample, volumeL, volumeR, disparity, scale)
    proAudio.sleep(duration)
    proAudio.soundStop(sound)
end
