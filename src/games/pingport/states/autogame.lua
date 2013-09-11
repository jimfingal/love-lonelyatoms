require 'external.middleclass'
require 'engine.spritegroup'
require 'sprites.player'
require 'sprites.ball'
require 'sprites.tile'


AutoGame = class('AutoGame')

function AutoGame:initialize()

    self.auto_player = Player('player', 350, 500, 100, 20)

    self.auto_player:setFill(147,147,205, 150)

    self.auto_ball = Ball('ball', 395, 500 - 15, 15, 15)
    self.auto_ball:setFill(220,220,204, 150)

    self.auto_world_edges = SpriteGroup('tiles', false, false)

    -- Tends to fall off world
    local TILE_SIZE = 20

    local top_tile = Tile('x' .. tostring(i), 0, -1 * TILE_SIZE, love.graphics.getWidth(), TILE_SIZE)
    local bottom_tile = Tile('x' .. tostring(i), 0, love.graphics.getHeight(), love.graphics.getWidth(), TILE_SIZE)
    local left_tile = Tile('y' .. tostring(i), -1 * TILE_SIZE, 0, TILE_SIZE, love.graphics.getHeight())
    local right_tile = Tile('y' .. tostring(i), love.graphics.getWidth(), 0, TILE_SIZE, love.graphics.getHeight())

    self.auto_world_edges:add(top_tile)
    self.auto_world_edges:add(bottom_tile)   
    self.auto_world_edges:add(left_tile)
    self.auto_world_edges:add(right_tile)

    self.debug = false
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

    if self.debug then

        love.graphics.print("Ball x: " .. self.auto_ball.shape.upper_left.x, 50, debugstart + 20)
        love.graphics.print("Ball y: " .. self.auto_ball.shape.upper_left.y, 50, debugstart + 40)
        love.graphics.print("Player x: " .. self.auto_player.shape.upper_left.x, 50, debugstart + 60)
        love.graphics.print("Player y: " .. self.auto_player.shape.upper_left.y, 50, debugstart + 80)
    end

end


-- Special off-world handling for long load times

function AutoGame:constrainActorsToWorld()

    if self.auto_ball.shape.transform.position.x < 0 then
        self.auto_ball.shape.transform.position.x = 0
    elseif self.auto_ball.shape.transform.position.x > love.graphics.getWidth() then
        self.auto_ball.shape.transform.position.x = love.graphics.getWidth()
    elseif self.auto_ball.shape.transform.position.y < 0 then
        self.auto_ball.shape.transform.position.y = 0
    elseif self.auto_ball.shape.transform.position.y > love.graphics.getHeight() then
        self.auto_ball.shape.transform.position.y = love.graphics.getHeight()
    end

    if self.auto_player.shape.transform.position.x < 0 then
        self.auto_player.shape.transform.position.x = 0
    elseif self.auto_player.shape.transform.position.x > love.graphics.getWidth() - self.auto_player.shape.width then
        self.auto_player.shape.transform.position.x = love.graphics.getWidth() - self.auto_player.shape.width
    end

end