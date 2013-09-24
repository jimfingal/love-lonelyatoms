require 'external.middleclass'
require 'core.entity.system'

MovementSystem = class('MovementSystem', System)

function MovementSystem:initialize()
	System.initialize(self, 'Movement System')

end

function MovementSystem:updateMovables(entities, dt)

	for entity in entities:members() do
	
		local t = entity:getComponent(Transform)
        local m = entity:getComponent(Motion)

        assert(m.velocity and m.velocity.x and m.velocity.y, "Entity should have velocity... " .. tostring(entity))
        assert(m.acceleration, "Entity should have acceleration... " .. tostring(entity))

        self:update(t, m, dt)

	end

end


function MovementSystem:update(transform, movement, dt)

	if movement.drag then
	 	if movement.velocity > Vector.ZERO then
	        
	        movement.velocity = movement.velocity - (movement.drag * dt)

	        if movement.velocity < Vector.ZERO then
	            movement.velocity = Vector.ZERO
	        end

	    elseif movement.velocity < Vector.ZERO then

	        movement.velocity = movement.velocity + (movement.drag * dt)

	        if movement.velocity > Vector.ZERO then
	            movement.velocity = Vector.ZERO
	        end

	    end
	end

    movement:capVelocity()

    -- TODO - Verlet

    movement.velocity = movement.velocity + (movement.acceleration * dt)

    local new_position = transform.position + (movement.velocity * dt) 

    transform:moveTo(new_position.x, new_position.y)

 end