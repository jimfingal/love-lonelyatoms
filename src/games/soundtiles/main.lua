require 'audio.frequency'
require 'audio.audioengine'
require 'audio.audiomodulator'

require 'audio.waves'
require 'core.systems.inputsystem'
require 'external.middleclass'

require 'utils.counters'

Actions = {}

Actions.CHANGE_WAVE_UP = "up"
Actions.CHANGE_WAVE_DOWN = "down"


Actions.CHANGE_NOTE_UP = "noteup"
Actions.CHANGE_NOTE_DOWN = "notedown"

wave_types = {}
wave_types[1]  = Waves.SQUARE
wave_types[2] = Waves.SAWTOOTH
wave_types[3] = Waves.SINE
wave_types[4] = Waves.TRIANGLE

counter = CircularCounter(4, 1)
note_off_a = Counter()

current_wave = wave_types[1]

DEBUG = true
frame = 1
memsize = 0

function love.load()
    
    local buffer_length = 1

    engine = AudioEngine()
    
 

    audio = engine:newAudio(Waves.SAWTOOTH, buffer_length, 440)


    input_system = InputSystem()
    input_system:registerInput('up', Actions.CHANGE_WAVE_UP)
    input_system:registerInput('down', Actions.CHANGE_WAVE_DOWN)
    input_system:registerInput('w', Actions.CHANGE_NOTE_UP)
    input_system:registerInput('s', Actions.CHANGE_NOTE_DOWN)
   


end


-- Perform computations, etc. between screen refreshes.
function love.update(dt)

    input_system:update(dt)
    

    change = false

    if input_system:newAction(Actions.CHANGE_WAVE_UP) then
        counter:increment()
        change = true
    elseif input_system:newAction(Actions.CHANGE_WAVE_DOWN) then
        counter:decrement()
        change = true
    elseif input_system:newAction(Actions.CHANGE_NOTE_UP) then
        note_off_a:increment()
        change = true
    elseif input_system:newAction(Actions.CHANGE_NOTE_DOWN) then
        note_off_a:decrement()
        change = true
    end

    if change or frame == 1 then

        current_wave = wave_types[counter:value()]
        
        createAndPlayNote(note_off_a, current_wave)

    end

end

function createAndPlayNote(note_off_a, wave_type)

    fm = engine:newAudioModulator(Waves.SINE)
    fm.amplitude = 20
    fm.frequency = 0.1

    --am = engine:newAudioModulator(Waves.SINE)

    audio.waveform = current_wave
    audio.frequency = frequencyFromNote(note_off_a:value())
    audio.frequency_modulator = fm
    --audio.amplitude_modulator = am

    audio:generateSamples()

    soundData = love.sound.newSoundData(audio.duration * engine.sample_rate, engine.sample_rate, 16, 1)
    
    engine:setSamples(soundData, audio)

    local sound = love.audio.newSource(soundData)
    sound:setLooping(true)

    love.audio.stop()
    love.audio.play(sound)

end



-- Update the screen.

function love.draw()



    if DEBUG then
       local debugstart = 50
        love.graphics.setColor(255, 255, 255)
        love.graphics.print("FPS: " .. love.timer.getFPS(), 50, debugstart + 20)
        love.graphics.print("Counter: " .. tostring(counter), 50, debugstart + 40)
        love.graphics.print("Waveform: " .. tostring(current_wave), 50, debugstart + 60)
        love.graphics.print("Note off A: " .. tostring(note_off_a), 50, debugstart + 80)
        love.graphics.print("Frequency in Hz: " .. tostring(audio.frequency), 50, debugstart + 100)

        frame = frame + 1

        if frame % 10 == 0 then
            memsize = collectgarbage('count')
        end

        love.graphics.print('Memory actually used (in kB): ' .. memsize, 10, debugstart + 320)
    end

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
