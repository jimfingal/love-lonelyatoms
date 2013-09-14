

function collideBallWithPaddle(ball, paddle)

	local new_y = paddle.position.y - self.height
	self:moveTo(self.position.x, new_y)


	-- Compare X with paddle x

	local paddle_origin = paddle.position.x
	local paddle_width = paddle.width
	local third_of_paddle = paddle_width / 3

	local middle_ball = self.position.x + self.width/2

	local first_third = paddle_origin + third_of_paddle
	local second_third = first_third + third_of_paddle
	local third_third = paddle_origin + paddle_width

	if middle_ball <= first_third then

		-- Reverse y direction and hit to left
		self.velocity.y = -self.velocity.y
		self.velocity.x = self.velocity.x - paddle_english

	elseif middle_ball > first_third and middle_ball < second_third then

		-- Reverse y direction
		self.velocity.y = -self.velocity.y

		-- Slow x direction down
		if self.velocity.x > 0 then

			self.velocity.x = self.velocity.x - paddle_english/2

		elseif self.velocity.x < 0 then

			self.velocity.x = self.velocity.x + paddle_english/2

		end

	elseif middle_ball > second_third then

		-- Reverse y direction and hit to right
		self.velocity.y = -self.velocity.y
		self.velocity.x = self.velocity.x + paddle_english

	end	

end


function collideBallWithWall(ball, wall)

	local collider_position = wall.position

	-- Top wall
	if collider_position.y < 0 then

		self:moveTo(self.position.x, 1)
		self:invertVerticalVelocity()

	-- Bottom wall

	elseif collider_position.y >= love.graphics.getHeight() then

		self:disable()

	elseif collider_position.x <= love.graphics.getHeight() then

		self:moveTo(1, self.position.y)
		self:invertHorizontalVelocity()

	else
		self:moveTo(love.graphics.getWidth() - self.width, self.position.y)
		self:invertHorizontalVelocity()
	end

end


function collideBallWithBrick(ball, brick)

	brick:playDeathSound()
	brick.active = false
	-- death animation

	Tweener:addTween(1, brick, {width = 0, height = 0}, Easing.linear)
	Tweener:addTween(1, brick.position, {x = brick.position.x + 100, y = brick.position.y + 300}, Easing.inBack)
	Tweener:addTween(1, brick.color, {alpha = 0}, Easing.inCubic)


	-- TODO handle bullet shit

	-- Colliding from the left or right
	if self.position.x < brick.position.x or
	   self.position.x > brick.position.x + brick.width then
		self:invertHorizontalVelocity()
	else
		self:invertVerticalVelocity()
	end

end

function collidePlayerWithWall(player, wall)


end

