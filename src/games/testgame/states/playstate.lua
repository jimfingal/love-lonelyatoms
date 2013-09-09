require 'external.middleclass'
require 'engine.gamestate'
require 'engine.spritegroup'
require 'sprites.player'
require 'sprites.ball'
require 'sprites.tile'
require 'collections.set'
Input = require 'engine.input'
require 'brickloader'

PlayState = class('Play', GameState)

function PlayState:initialize(name, state_manager, asset_manager)

    GameState.initialize(self, name, state_manager, asset_manager)

    self.world = SpriteGroup('allsprites', true, true)
    self.world_edges = SpriteGroup('tiles', false, false)

   
    self.bricks = BrickLoader.load_bricks()
    self.world:add(self.bricks)

    local TILE_SIZE = 50

    local top_tile = Tile('x' .. tostring(i), 0, -1 * TILE_SIZE, love.graphics.getWidth(), TILE_SIZE)
    local bottom_tile = Tile('x' .. tostring(i), 0, love.graphics.getHeight(), love.graphics.getWidth(), TILE_SIZE)
    local left_tile = Tile('y' .. tostring(i), -1 * TILE_SIZE, TILE_SIZE, TILE_SIZE, love.graphics.getHeight() - TILE_SIZE)
    local right_tile = Tile('y' .. tostring(i), love.graphics.getWidth(), TILE_SIZE, TILE_SIZE, love.graphics.getHeight() - TILE_SIZE)

    self.world:add(top_tile)
    self.world:add(bottom_tile)   
    self.world:add(left_tile)
    self.world:add(right_tile)

    self.world_edges:add(top_tile)
    self.world_edges:add(bottom_tile)   
    self.world_edges:add(left_tile)
    self.world_edges:add(right_tile)


    self.player = Player('player', 350, 500, 100, 10)
    self.world:add(self.player)

    self.ball = Ball('ball', 395, 489, 10, 10)
    self.world:add(self.ball)


    self.debug = true


    self.input = InputManager()

    self.input:registerInput('right', Actions.PLAYER_RIGHT)
    self.input:registerInput('left', Actions.PLAYER_LEFT)
    self.input:registerInput('a', Actions.PLAYER_LEFT)
    self.input:registerInput('d', Actions.PLAYER_RIGHT)
    self.input:registerInput(' ', Actions.RESET_BALL)

end


function PlayState:update(dt)

    self.input:update(dt)

    -- TODO
    if self.input:newAction(Actions.RESET_BALL) then
        self.ball:reset(self.player)
    end

    self.world:processInput(dt, self.input)
    
    -- I want to be able to check a collision between one item, another item or group, and call a callback that
    -- handles the two items that collided if it happens
    self.player:processCollision(self.world_edges, function (player, collided_tile) player:collideWithWall(collided_tile) end)


    self.ball:processCollision(self.player, function(ball, paddle) ball:collideWithPaddle(paddle) end)

    self.ball:processCollision(self.world_edges, function(ball, wall) ball:collideWithWall(wall) end)

    self.ball:processCollision(self.bricks, function(ball, brick) ball:collideWithBrick(brick) end)


    self.world:update(dt)

    self.world:endFrame(dt)

end


function PlayState:draw()

    love.graphics.setBackgroundColor(63, 63, 63, 255)

    self.world:draw()

    love.graphics.setColor(204,147,147)
    love.graphics.setFont(self:assetManager():getFont(Assets.FONT_MEDIUM))
    
    menu_str = "PLAY AROUND!"

    love.graphics.print(menu_str, 200, 550)


    local debugstart = 575
    
	if self.debug then

        love.graphics.setFont(self:assetManager():getFont(Assets.FONT_SMALL))
        love.graphics.print(love.timer.getFPS(), 50, debugstart)

    end



end