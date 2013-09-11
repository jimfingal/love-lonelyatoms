require 'external.middleclass'
require 'engine.group'
require 'sprites.player'
require 'sprites.ball'
require 'sprites.tile'


AutoGame = class('AutoGame')

function AutoGame:initialize()

    self.auto_player = Player(350, 500, 100, 20)
    self.auto_player:setColor(147,147,205, 150)

    self.auto_ball = Ball(395, 500 - 15, 15, 15)
    self.auto_ball:setColor(220,220,204, 150)

    self.auto_world_edges = Group()

    -- Tends to fall off world
    local TILE_SIZE = 20

    local top_tile = Tile(0, -1 * TILE_SIZE, love.graphics.getWidth(), TILE_SIZE)
    local bottom_tile = Tile(0, love.graphics.getHeight(), love.graphics.getWidth(), TILE_SIZE)
    local left_tile = Tile(-1 * TILE_SIZE, 0, TILE_SIZE, love.graphics.getHeight())
    local right_tile = Tile(love.graphics.getWidth(), 0, TILE_SIZE, love.graphics.getHeight())

    self.auto_world_edges:add(top_tile)
    self.auto_world_edges:add(bottom_tile)   
    self.auto_world_edges:add(left_tile)
    self.auto_world_edges:add(right_tile)

end



function AutoGame:update(dt)

    self:constrainActorsToWorld()

    self.auto_player:processAI(dt, self.auto_ball)
    self.auto_player:update(dt)
    self.auto_ball:update(dt)

    self.auto_player:processCollision(self.auto_world_edges, function (player, collided_tile) player:collideWithWall(collided_tile) end)
    self.auto_ball:processCollision(self.auto_player, function(ball, paddle) ball:collideWithPaddle(paddle) end)
    self.auto_ball:processCollision(self.auto_world_edges, function(ball, wall) ball:collideWithWall(wall) end)

    if self.auto_ball.active == false then
        self.auto_ball:reset(self.auto_player)
    end

end


function AutoGame:draw()

    self.auto_player:draw()
    self.auto_ball:draw()

    local debugstart = 400

    if DEBUG then

        love.graphics.print("Ball x: " .. self.auto_ball.position.x, 50, debugstart + 20)
        love.graphics.print("Ball y: " .. self.auto_ball.position.y, 50, debugstart + 40)
        love.graphics.print("Player x: " .. self.auto_player.position.x, 50, debugstart + 60)
        love.graphics.print("Player y: " .. self.auto_player.position.y, 50, debugstart + 80)
    end

end


-- Special off-world handling for long load times

function AutoGame:constrainActorsToWorld()

    if self.auto_ball.position.x < 0 then
        self.auto_ball.position.x = 0
    elseif self.auto_ball.position.x > love.graphics.getWidth() then
        self.auto_ball.position.x = love.graphics.getWidth()
    elseif self.auto_ball.position.y < 0 then
        self.auto_ball.position.y = 0
    elseif self.auto_ball.position.y > love.graphics.getHeight() then
        self.auto_ball.position.y = love.graphics.getHeight()
    end

    if self.auto_player.position.x < 0 then
        self.auto_player.position.x = 0
    elseif self.auto_player.position.x > love.graphics.getWidth() - self.auto_player.shape.width then
        self.auto_player.position.x = love.graphics.getWidth() - self.auto_player.shape.width
    end

end