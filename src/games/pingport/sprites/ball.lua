require 'external.middleclass'
require 'engine.sprite'
require 'engine.rigidbody'
require 'engine.vector'
require 'engine.shapes'
require 'states.actions'

Ball = class('Ball', Sprite)

local default_x_vel = 200
local default_y_vel = -425

local paddle_english = 100

function Ball:initialize(name, x, y, width, height)

	sprite_and_collider_shape = RectangleShape(x, y, width, height)

	Sprite.initialize(self, name, sprite_and_collider_shape, sprite_and_collider_shape)

	self.active = true
	self.visible = true

	self:setFill(220,220,204)

	self.rigidbody = RigidBody()
    self.rigidbody:setMaxVelocity(600, 400)
    self.rigidbody:setMinVelocity(-600, -400)

    self.rigidbody:setVelocity(default_x_vel, default_y_vel)

end

function Ball:moveTo(x, y)

    self.shape:moveTo(x, y)
    self.collider:moveTo(x, y)

end


function Ball:reset(player)

	self:die()
    self:moveTo(player.shape.transform.position.x + player.shape.width / 2, player.shape.transform.position.y - self.shape.height)
    self.rigidbody:setVelocity(default_x_vel, default_y_vel)
    self:revive()

end

function Ball:collideWithPaddle(paddle)

	local new_y = paddle.shape.transform.position.y - self.shape.height
	self:moveTo(self.shape.transform.position.x, new_y)


	-- Compare X with paddle x

	local paddle_origin = paddle.shape.transform.position.x
	local paddle_width = paddle.shape.width
	local third_of_paddle = paddle_width / 3

	local middle_ball = self.shape.transform.position.x + self.shape.width/2

	local first_third = paddle_origin + third_of_paddle
	local second_third = first_third + third_of_paddle
	local third_third = paddle_origin + paddle_width

	if middle_ball <= first_third then

		-- Reverse y direction and hit to left
		self.rigidbody.velocity.y = -self.rigidbody.velocity.y
		self.rigidbody.velocity.x = self.rigidbody.velocity.x - paddle_english

	elseif middle_ball > first_third and middle_ball < second_third then

		-- Reverse y direction
		self.rigidbody.velocity.y = -self.rigidbody.velocity.y

		-- Slow x direction down
		if self.rigidbody.velocity.x > 0 then

			self.rigidbody.velocity.x = self.rigidbody.velocity.x - paddle_english/2

		elseif self.rigidbody.velocity.x < 0 then

			self.rigidbody.velocity.x = self.rigidbody.velocity.x + paddle_english/2

		end

	elseif middle_ball > second_third then

		-- Reverse y direction and hit to right
		self.rigidbody.velocity.y = -self.rigidbody.velocity.y
		self.rigidbody.velocity.x = self.rigidbody.velocity.x + paddle_english

	end	

end

function Ball:invertVerticalVelocity()
	self.rigidbody.velocity.y = -self.rigidbody.velocity.y
end

function Ball:invertHorizontalVelocity()
	self.rigidbody.velocity.x = -self.rigidbody.velocity.x
end

function Ball:collideWithWall(wall)

	local collider_position = wall.collider.transform.position

	-- Top wall
	if collider_position.y < 0 then

		self:moveTo(self.shape.transform.position.x, 1)
		self:invertVerticalVelocity()

	-- Bottom wall

	elseif collider_position.y >= love.graphics.getHeight() then

		self:die()

	elseif collider_position.x <= love.graphics.getHeight() then

		self:moveTo(1, self.shape.transform.position.y)
		self:invertHorizontalVelocity()

	else
		self:moveTo(love.graphics.getWidth() - self.shape.width, self.shape.transform.position.y)
		self:invertHorizontalVelocity()
	end

end


function Ball:collideWithBrick(brick)

	brick:playDeathSound()
	brick:die()

	-- TODO handle bullet shit

	-- Colliding from the left or right
	if self.shape.transform.position.x < brick.shape.transform.position.x or
	   self.shape.transform.position.x > brick.shape.transform.position.x + brick.shape.width then
		self:invertHorizontalVelocity()
	else
		self:invertVerticalVelocity()
	end

end



function Ball:update(dt)

    -- self:capVelocity()


    -- assert(false, "inspecting transform: " .. tostring(self.shape.transform))
    local new_position = self.shape.transform:vector() + (self.rigidbody.velocity * dt) 

    self:moveTo(new_position.x, new_position.y)

end

