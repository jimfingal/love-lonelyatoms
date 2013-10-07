require 'audio.frequency'
require 'audio.audioengine'
require 'audio.audiomodulator'

require 'audio.waves'
require 'core.systems.inputsystem'
require 'core.systems.schedulesystem'

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

    engine = AudioEngine()

    input_system = InputSystem()

    input_system:registerInput('up', Actions.CHANGE_WAVE_UP)
    input_system:registerInput('down', Actions.CHANGE_WAVE_DOWN)
    input_system:registerInput('w', Actions.CHANGE_NOTE_UP)
    input_system:registerInput('s', Actions.CHANGE_NOTE_DOWN)
    input_system:registerInput(' ', "reset")

    schedule_system = ScheduleSystem()


    local xtiles = 20
    local ytiles = 20

    screen_map = ScreenMap(love.graphics.getWidth(), love.graphics.getHeight(), xtiles, ytiles)

    mouse_x = 0
    mouse_y = 0

    clicked_matrix = Matrix(xtiles, ytiles, 0)
    sound_matrix = Matrix(xtiles, ytiles, nil)

    screen_counter = CircularCounter(xtiles, 1)

    current_wave = wave_types[1]

    time_interval = 0.1

    schedule_system:doEvery(time_interval, changeNotes)

end

function changeNotes()

    screen_counter:increment()

    for y = 1, screen_map.ytiles do
        
        local current = clicked_matrix:get(screen_counter:value(), y)

        if current == 1 then

            local existing_sound = sound_matrix:get(screen_counter:value(), y)

            if existing_sound then
                love.audio.play(existing_sound)
            else
                local new_sound = getNote(y, Waves.SINE, time_interval)
                sound_matrix:put(screen_counter:value(), y, new_sound)
                love.audio.play(new_sound)
            end
        end

    end

end


-- Perform computations, etc. between screen refreshes.
function love.update(dt)

    input_system:update(dt)
    
    mouse_x, mouse_y = love.mouse.getPosition()
    tile_hover = screen_map:getCoordinates(mouse_x, mouse_y)

    if input_system:newAction("reset") then
        clicked_matrix:populateDefault()
    end

    schedule_system:update(dt)


end

function getNote(note_off_a, wave_type, length)


    audio = engine:newAudio(wave_type, length, frequencyFromNote(note_off_a))

    audio:generateSamples()

    soundData = love.sound.newSoundData(audio.duration * engine.sample_rate, engine.sample_rate, 16, 1)
    
    engine:setSamples(soundData, audio)

    return love.audio.newSource(soundData)

end

function createAndPlayNote(note_off_a, wave_type, length)


    audio = engine:newAudio(wave_type, length, frequencyFromNote(note_off_a))

    audio:generateSamples()

    soundData = love.sound.newSoundData(audio.duration * engine.sample_rate, engine.sample_rate, 16, 1)
    
    engine:setSamples(soundData, audio)

    local sound = love.audio.newSource(soundData)

    love.audio.play(sound)

end



function love.mousepressed(x, y, button)
    mouse_x, mouse_y = love.mouse.getPosition()
    tile_hover = screen_map:getCoordinates(mouse_x, mouse_y)
    local x, y = tile_hover:unpack()
    local current = clicked_matrix:get(x, y)
    local new = 1
    if current == 1 then new = 0 end
    clicked_matrix:put(x, y, new)
end



-- Update the screen.

function love.draw()


    love.graphics.setBackgroundColor(63, 63, 63, 255)

    drawScreenTiles(screen_map)

    love.graphics.setColor(63,63,63, 20)
    love.graphics.rectangle("fill", (screen_counter:value() - 1)  * screen_map.tile_width, 0, screen_map.tile_width, love.graphics.getHeight())



    if DEBUG then
       local debugstart = 50
        love.graphics.setColor(255, 255, 255)
        love.graphics.print("FPS: " .. love.timer.getFPS(), 50, debugstart + 20)

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

            if current % 2 == 1 then alpha = 255 end

            love.graphics.setColor(r,g,b, alpha)

            love.graphics.rectangle("fill", x * screen_map.tile_width, y * screen_map.tile_height, screen_map.tile_width, screen_map.tile_height)
           
        end
    end


end

