require 'core.components.transform'
require 'core.components.rendering'
require 'core.components.collider'
require 'core.components.motion'
require 'core.vector'

require 'enums.scenes'
require 'enums.tags'

-- Special off-world handling for long load times
function constrainActorsToWorld(constrainer, dt)

    local em = constrainer:getWorld():getEntityManager()

    local player_transform =  world:getTaggedEntity(Tags.PLAYER):getComponent(Transform)
    local player_collider = world:getTaggedEntity(Tags.PLAYER):getComponent(Collider)

    local ball_transform = world:getTaggedEntity(Tags.BALL):getComponent(Transform)


    if ball_transform.position.x < 0 then
        ball_transform.position.x = 0
    elseif ball_transform.position.x > love.graphics.getWidth() then
        ball_transform.position.x = love.graphics.getWidth()
    end

    if ball_transform.position.y < 0 then
        ball_transform.position.y = 0
    elseif ball_transform.position.y > love.graphics.getHeight() then
        ball_transform.position.y = love.graphics.getHeight()
    end

    if player_transform.position.x < 0 then
        player_transform.position.x = 0
    elseif player_transform.position.x > love.graphics.getWidth() - player_collider:hitbox().width then
        player_transform.position.x = love.graphics.getWidth() - player_collider:hitbox().width
    end

end


function globalInputResponse(global, held_actions, pressed_actions, dt)

    -- Escape to Menu
    if pressed_actions[Actions.RESET_BOARD] then

        global:getWorld():getSceneManager():changeScene(Scenes.PLAY)
    
    end



    move_speed = 100
    scale_speed = 2
    rotate_speed = 1

    local camera = global:getWorld():getSystem(CameraSystem).transform

    if held_actions[Actions.CAMERA_LEFT] then
        camera:move(-dt * move_speed, 0)
    end

    if held_actions[Actions.CAMERA_RIGHT] then
        camera:move(dt * move_speed, 0)
    end

    if held_actions[Actions.CAMERA_UP] then
        camera:move(0, -dt * move_speed)
    end

    if held_actions[Actions.CAMERA_DOWN] then
        camera:move(0, dt * move_speed)
    end

    if held_actions[Actions.CAMERA_SCALE_UP] then
        camera:addScale(dt * scale_speed)
    end

    if held_actions[Actions.CAMERA_SCALE_DOWN] then
        camera:addScale(-dt * scale_speed)
    end



    -- Quit
    if pressed_actions[Actions.QUIT_GAME] then
        love.event.push("quit")
    end

end

