
require 'external.middleclass'
require 'entity.entitybuilder'

GlobalInputBuilder  = class('GlobalInputBuilder', EntityBuilder)

function GlobalInputBuilder:initialize(world)
    EntityBuilder.initialize(self, world, 'globalinputs')
    return self
end

function GlobalInputBuilder:create()

    EntityBuilder.create(self)

    local globalInputResponse = function(entity, held_actions, pressed_actions, dt)

        -- Reset the Board
        if pressed_actions[Actions.RESET_BOARD] then
            entity:getWorld():getSceneManager():changeScene(Scenes.PLAY)
        end

        -- Quit
        if pressed_actions[Actions.QUIT_GAME] then
            love.event.push("quit")
        end

    end

    self.entity:addComponent(InputResponse():addResponse(globalInputResponse))
    self.entity:addToGroup(Tags.PLAY_GROUP)

end