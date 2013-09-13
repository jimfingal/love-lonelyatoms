require 'external.middleclass'
require 'core.gamestate'
require 'core.entity.group'
require 'sprites.player'
require 'sprites.ball'
require 'sprites.tile'
require 'collections.set'
Input = require 'core.input'
require 'config.brickloader'
require 'assets.assets'
require 'core.tween'


PlayState = class('Play', GameState)

function PlayState:initialize(name, state_manager, asset_manager)

    GameState.initialize(self, name, state_manager, asset_manager)

    self.world_edges = Group()
    self.bricks = Group()

    local TILE_SIZE = 50

    local top_tile = Tile(0, -1 * TILE_SIZE, love.graphics.getWidth(), TILE_SIZE)
    local bottom_tile = Tile(0, love.graphics.getHeight(), love.graphics.getWidth(), TILE_SIZE)
    local left_tile = Tile(-1 * TILE_SIZE, 0, TILE_SIZE, love.graphics.getHeight())
    local right_tile = Tile(love.graphics.getWidth(), 0, TILE_SIZE, love.graphics.getHeight())

    self.world_edges:add(top_tile)
    self.world_edges:add(bottom_tile)   
    self.world_edges:add(left_tile)
    self.world_edges:add(right_tile)

    self.player = Player(350, 500, 100, 20)    
    self.ball = Ball(395, 500 - 15, 15, 15)

    self.input = InputManager()

    self.input:registerInput('right', Actions.PLAYER_RIGHT)
    self.input:registerInput('left', Actions.PLAYER_LEFT)
    self.input:registerInput('a', Actions.PLAYER_LEFT)
    self.input:registerInput('d', Actions.PLAYER_RIGHT)
    self.input:registerInput(' ', Actions.RESET_BALL)
    self.input:registerInput('escape', Actions.ESCAPE_TO_MENU)
    self.input:registerInput('q', Actions.QUIT_GAME)

    self.victory = false

end

function PlayState:enter(brick_input)

    self.input:clear()
    self.player:stop()
    self.player:moveTo(350, 500)
    self.ball:disable()

    self.victory = false

    -- Loading....
    love.graphics.setBackgroundColor(63, 63, 63, 255)
    love.graphics.setColor(204,147,147)
    love.graphics.setFont(self:assetManager():getFont(Assets.FONT_MEDIUM))
    love.graphics.print("Loading...", 200, 550)

    -- Reset bricks
    self.brick_config = BrickLoader:load_bricks(self.asset_manager, brick_input)

    self.bricks = self.brick_config.bricks

    local background = self.brick_config.background_snd
    
    love.audio.stop()
    background:setVolume(0.25)
    background:setLooping(true)
    love.audio.play(background)

 
end


function PlayState:update(dt)

    self.input:update(dt)
    Tweener:update(dt)

    -- Reset Ball
    if self.input:newAction(Actions.RESET_BALL) and not self.victory then
        self.ball:reset(self.player)
    end

    -- Escape to Menu
    if self.input:newAction(Actions.ESCAPE_TO_MENU) then
        self.ball:disable()
        self.state_manager:changeState(States.MENU)
    end

    -- Quit
    if self.input:newAction(Actions.QUIT_GAME) then
        love.event.push("quit")
    end

    self.player:processInput(dt, self.input)    

    if self.player.active then

         -- I want to be able to check a collision between one item, another item or group, and call a callback that
        -- handles the two items that collided if it happens
        self.player:processCollision(self.world_edges, function (player, collided_tile) player:collideWithWall(collided_tile) end)
    end

    if self.ball.active then

        self.ball:processCollision(self.player, function(ball, paddle) ball:collideWithPaddle(paddle) end)

        self.ball:processCollision(self.world_edges, function(ball, wall) ball:collideWithWall(wall) end)

        self.ball:processCollision(self.bricks, function(ball, brick) ball:collideWithBrick(brick) end)

    end

    -- TODO make more explicit what is happening in this phase?
    self.player:update(dt)
    self.ball:update(dt)

    self.victory = true
    for _, brick in self.bricks:members() do
        if brick.active then
            self.victory = false
            break
        end
    end



end


function PlayState:draw()

    love.graphics.setBackgroundColor(63, 63, 63, 255)

    self.bricks:draw()
    self.player:draw()
    self.ball:draw()

    if self.victory then
        love.graphics.setColor(204,147,147)
        love.graphics.setFont(self:assetManager():getFont(Assets.FONT_LARGE))
        love.graphics.print("YOU WIN!!!", 200, 200)
        self.ball:disable()

    elseif not self.ball.active then

        -- Only display if we haven't won
        love.graphics.setColor(204,147,147)
        love.graphics.setFont(self:assetManager():getFont(Assets.FONT_MEDIUM))
        love.graphics.print("Press Space to Launch Ball", 200, 550)
    end

    local debugstart = 300

	if DEBUG then

        love.graphics.setFont(self:assetManager():getFont(Assets.FONT_SMALL))
        love.graphics.print(love.timer.getFPS(), 50, debugstart)
        love.graphics.print("Ball x: " .. self.ball.position.x, 50, debugstart + 20)
        love.graphics.print("Ball y: " .. self.ball.position.y, 50, debugstart + 40)

    end


end