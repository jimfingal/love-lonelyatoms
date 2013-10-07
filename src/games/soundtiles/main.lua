require 'audio.frequency'
require 'audio.audioengine'
require 'audio.audiomodulator'

require 'audio.waves'
require 'core.systems.inputsystem'
require 'external.middleclass'

require 'utils.counters'

require 'spatial.screenmap'
require 'collections.matrix'

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
    input_system:registerInput(' ', "reset")


    screen_map = ScreenMap(love.graphics.getWidth(), love.graphics.getHeight(), 10, 10)

    mouse_x = 0
    mouse_y = 0

    clicked_matrix = Matrix(10, 10, 0)

    counter = CircularCounter(4, 1)
    note_off_a = Counter()

    current_wave = wave_types[1]

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

    mouse_x, mouse_y = love.mouse.getPosition()
    tile_hover = screen_map:getCoordinates(mouse_x, mouse_y)

    if input_system:newAction("reset") then
        clicked_matrix:populateDefault()
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



function love.mousepressed(x, y, button)
    mouse_x, mouse_y = love.mouse.getPosition()
    tile_hover = screen_map:getCoordinates(mouse_x, mouse_y)
    local x, y = tile_hover:unpack()
    local current = clicked_matrix:get(x, y)
    clicked_matrix:put(x, y, current + 1)
end



-- Update the screen.

function love.draw()


    love.graphics.setBackgroundColor(63, 63, 63, 255)

    drawScreenTiles(screen_map)

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


function drawScreenTiles(screen_map)

    local r = 200
    local b = 40

    for x = 0, screen_map.xtiles - 1 do 

        r = r - 10
        b = b + 10
        local g = 50

        for y = 0, screen_map.ytiles - 1 do

            g = g + 10

            local alpha = 200
            local current = clicked_matrix:get(x + 1, y + 1)

            assert(current, "There should be a current for " .. x + 1 .. ", " ..y + 1 .. " but instead there is not..." .. tostring(clicked_matrix))

            if current % 2 == 1 then alpha = 255 end

            love.graphics.setColor(r,g,b, alpha)

            love.graphics.rectangle("fill", x * screen_map.tile_width, y * screen_map.tile_height, screen_map.tile_width, screen_map.tile_height)
           
            love.graphics.print(tostring(current), x * screen_map.tile_width, y * screen_map.tile_height)
        end
    end


end

