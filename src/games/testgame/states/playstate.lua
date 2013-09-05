require 'class.middleclass'
require 'engine.gamestate'
require 'engine.sprite'

PlayState = class('Play', GameState)

function PlayState:initialize(name, state_manager, asset_manager)

    GameState.initialize(self, name, state_manager, asset_manager)

    -- self.player = Sprite()

end


function PlayState:update(dt)

end


function PlayState:draw()
    love.graphics.setColor(204,147,147)
    love.graphics.setFont(self:assetManager():getFont(Assets.FONT_LARGE))
    menu_str = "PLAY AROUND!"
    love.graphics.print(menu_str, 200, 25)
end