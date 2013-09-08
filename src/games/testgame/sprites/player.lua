require 'external.middleclass'
require 'engine.sprite'
require 'engine.rigidbody'
require 'engine.vector'

Player = class('Player', Sprite)


function Player:initialize(name, x, y, width, height)

	Sprite.initialize(self, name, x, y, width, height)

	self.active = true
	self.visible = true

	self:setFill(147,147,205)

    self.rigidbody = RigidBody()
    self.rigidbody:setMaxVelocity(800, 0)
    self.rigidbody:setMinVelocity(-800, 0)
    self.rigidbody:setDrag(10, 0)

    self.speed_delta = Vector(40, 0)

end


function Player:startFrame(dt)

        -- Paddle right.
    if love.keyboard.isDown("right") then

        self.rigidbody.velocity = self.rigidbody.velocity + (self.speed_delta * dt)

    -- Paddle left.    
    elseif love.keyboard.isDown("left") then

        self.rigidbody.velocity = self.rigidbody.velocity - (self.speed_delta * dt)

    -- If left or right isn't being pressed, slow the paddle down. 
    else
    
        if self.rigidbody.velocity > Vector.zero then
            
            self.rigidbody.velocity = self.rigidbody.velocity - (self.rigidbody.drag * dt)

            if self.rigidbody.velocity < Vector.zero then
                self.rigidbody.velocity = Vector.zero
            end

        elseif self.rigidbody.velocity < Vector.zero then

            self.rigidbody.velocity = self.rigidbody.velocity + (self.rigidbody.drag * dt)

            if self.rigidbody.velocity > Vector.zero then
                self.rigidbody.velocity = Vector.zero
            end

        end
    end

end

function Player:update(dt)

    if self.rigidbody.velocity > self.rigidbody.maxVelocity then
    	self.rigidbody.velocity = self.rigidbody.maxVelocity
    elseif self.rigidbody.velocity < self.rigidbody.minVelocity then
    	self.rigidbody.velocity = self.rigidbody.minVelocity
    end
        

	self.transform.position = self.transform.position + self.rigidbody.velocity

    --[[ Process translations based on Velocity

    if self.paddle.x < (GameWindow.screen.width - self.paddle.width) then 
        self.paddle.x = self.paddle.x + (self.paddle.speed * dt )
    else
        self.paddle.x = (GameWindow.screen.width - self.paddle.width) 
        self.paddle.speed = 0
    end
	]]

			--[[ Reset to within screen 
        if self.paddle.x > GameWindow.screen.origin then
            self.paddle.x = self.paddle.x - (self.paddle.speed * dt )
        else
            self.paddle.x = GameWindow.screen.origin
            self.paddle.speed = 0
        end
        self.paddle.direction = "left"
        --]]
end

function Player:onCollide(other)
    if other.class == 'Tile' then
        self.rigidbody.velocity = Vector.zero
    end
end

