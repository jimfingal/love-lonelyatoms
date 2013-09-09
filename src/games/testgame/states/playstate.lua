require 'external.middleclass'
require 'engine.gamestate'
require 'engine.spritegroup'
require 'sprites.player'
require 'sprites.tile'
require 'collections.set'
Input = require 'engine.input'

PlayState = class('Play', GameState)

function PlayState:initialize(name, state_manager, asset_manager)

    GameState.initialize(self, name, state_manager, asset_manager)

    self.player = Player('player', 50, 500, 50, 50)

    self.world_edges = SpriteGroup('tiles', false, false)

    self.world = SpriteGroup('allsprites', true, true)
    self.world:add(self.player)


    local TILE_SIZE = 10

    local top_tile = Tile('x' .. tostring(i), 0, 0, love.graphics.getWidth(), TILE_SIZE)
    local bottom_tile = Tile('x' .. tostring(i), 0, love.graphics.getHeight() - TILE_SIZE, love.graphics.getWidth(), TILE_SIZE)
    local left_tile = Tile('y' .. tostring(i), 0, TILE_SIZE, TILE_SIZE, love.graphics.getHeight() - TILE_SIZE)
    local right_tile = Tile('y' .. tostring(i), love.graphics.getWidth() - TILE_SIZE, TILE_SIZE, TILE_SIZE, love.graphics.getHeight() - TILE_SIZE)

    self.world:add(top_tile)
    self.world:add(bottom_tile)   
    self.world:add(left_tile)
    self.world:add(right_tile)

    self.world_edges:add(top_tile)
    self.world_edges:add(bottom_tile)   
    self.world_edges:add(left_tile)
    self.world_edges:add(right_tile)

    self.debug = true


    self.input = InputManager()

    self.input:registerInput('right', Actions.PLAYER_RIGHT)
    self.input:registerInput('left', Actions.PLAYER_LEFT)
    self.input:registerInput('a', Actions.PLAYER_LEFT)
    self.input:registerInput('d', Actions.PLAYER_RIGHT)


end


function PlayState:update(dt)

    self.input:update(dt)

    self.world:processInput(dt, self.input)
    
    -- I want to be able to check a collision between one item, another item or group, and call a callback that
    -- handles the two items that collided if it happens
    self.player:processCollision(self.world_edges, function (player, collided_tile) player:collideWithImmovableRectangle(collided_tile) end)

    self.world:update(dt)

    self.world:endFrame(dt)

end


function PlayState:draw()

    love.graphics.setBackgroundColor(63, 63, 63, 255)

    self.world:draw()

    love.graphics.setColor(204,147,147)
    love.graphics.setFont(self:assetManager():getFont(Assets.FONT_LARGE))
    
    menu_str = "PLAY AROUND!"

    love.graphics.print(menu_str, 200, 25)


    local debugstart = 50
    
	if self.debug then

        love.graphics.setFont(self:assetManager():getFont(Assets.FONT_SMALL))
        love.graphics.print(love.timer.getFPS(), 50, debugstart)

    end



end