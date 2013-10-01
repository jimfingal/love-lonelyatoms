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

	-- Pulling native vector operations out for reduced object creation

    if movement.acceleration ~= Vector.ZERO then
	    local acceleration_effect_x = movement.acceleration.x * dt
	    local acceleration_effect_y = movement.acceleration.y * dt

	    movement.velocity.x =  movement.velocity.x  + acceleration_effect_x
	    movement.velocity.y =  movement.velocity.y  + acceleration_effect_y
	end

	
	if movement.drag then

		local drag_x = movement.drag.x * dt
		local drag_y = movement.drag.y * dt

	 	if movement.velocity > Vector.ZERO then
	        
	        movement.velocity.x = movement.velocity.x - drag_x
	        movement.velocity.y = movement.velocity.y - drag_y

	        if movement.velocity < Vector.ZERO then
	        	movement.velocity.x = 0
	        	movement.velocity.y = 0

	        end

	    elseif movement.velocity < Vector.ZERO then

	        movement.velocity.x = movement.velocity.x + drag_x
	        movement.velocity.y = movement.velocity.y + drag_y

  			if movement.velocity > Vector.ZERO then
	        	movement.velocity.x = 0
	        	movement.velocity.y = 0
	        end

	    end
	end
	
    movement:capVelocity()

	if movement.velocity ~= Vector.ZERO then

	    local movement_x = movement.velocity.x  * dt
	    local movement_y = movement.velocity.y  * dt

	    transform:move(movement_x, movement_y)
	end

 end