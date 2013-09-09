require 'external.middleclass'
require 'engine.sprite'
require 'engine.rigidbody'
require 'engine.vector'
require 'states.actions'
require 'engine.shapes'

Player = class('Player', Sprite)


function Player:initialize(name, x, y, width, height)

	sprite_and_collider_shape = RectangleShape(x, y, width, height)

    Sprite.initialize(self, name, sprite_and_collider_shape, sprite_and_collider_shape)

    self.leftEdge = RectangleShape(x, y, width / 2, height)
    self.rightEdge = RectangleShape(x + width - 1, y, width / 2, height)

	self.active = true
	self.visible = true

	self:setFill(147,147,205)

    self.rigidbody = RigidBody()
    self.rigidbody:setMaxVelocity(800, 0)
    self.rigidbody:setMinVelocity(-800, 0)
    self.rigidbody:setDrag(10, 0)

    self.speed_delta = Vector(1500, 0)
    self.base_speed = Vector(200, 0)

end


function Player:moveTo(x, y)

    self.shape:moveTo(x, y)
    self.collider:moveTo(x, y)
    self.leftEdge:moveTo(x, y)
    self.rightEdge:moveTo(x + (self.shape.width/2), y)
end

function Player:accelerateRight(dt)
    self.rigidbody.velocity = self.rigidbody.velocity + (self.speed_delta * dt)
end


function Player:accelerateLeft(dt)
    self.rigidbody.velocity = self.rigidbody.velocity - (self.speed_delta * dt)
end

function Player:capVelocity()
    if self.rigidbody.velocity > self.rigidbody.maxVelocity then
        self.rigidbody.velocity = self.rigidbody.maxVelocity
    elseif self.rigidbody.velocity < self.rigidbody.minVelocity then
        self.rigidbody.velocity = self.rigidbody.minVelocity
    end
end

function Player:applyDrag(dt)

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

function Player:processInput(dt, input)

    if input:heldAction(Actions.PLAYER_RIGHT) then
    
        self:accelerateRight(dt)
    
    elseif input:heldAction(Actions.PLAYER_LEFT) then
    
        self:accelerateLeft(dt)

    else
        self:applyDrag(dt)
    
    end

end

function Player:collideWithImmovableRectangle(collided_sprite)

    assert(instanceOf(RectangleShape, collided_sprite.collider), "Can only be applied to rectangles")

    local collided_position = collided_sprite.collider.transform.position


    -- If something is immovable, then I could only collide with it in the direction I'm going
    if self.leftEdge:collidesWith(collided_sprite.collider) then

        -- Translate to be on the other side of it

        local new_x = collided_position.x + collided_sprite.collider.width + 1

        self:moveTo(new_x, self.shape.transform.position.y)

    elseif self.rightEdge:collidesWith(collided_sprite.collider) then

        -- Translate to be on the other side of it
        self:moveTo(collided_position.x - self.collider.width - 1, self.shape.transform.position.y)

    else 

        assert(false, "Collided but didn't detect right or left edge collision " .. tostring(self.shape) .. tostring(self.rightEdge) .. tostring(collided_sprite.collider))

    end

    -- Reverse Velocity


    self.rigidbody.velocity = -self.rigidbody.velocity


end

function Player:update(dt)

    self:capVelocity()


    -- assert(false, "inspecting transform: " .. tostring(self.shape.transform))
    local new_position = self.shape.transform:vector() + (self.rigidbody.velocity * dt) 

    self:moveTo(new_position.x, new_position.y)

end

