require 'entity.components.transform'
require 'entity.components.motion'

AI = {}


function AI.move(entity, direction_angle, speed, time)

  local transform = entity:getComponent(Transform)
  local motion = entity:getComponent(Motion)

  local direction_vector = Vector.fromAngle(direction_angle)

  local velocity = direction_vector * speed

  local elapsed = 0

  while elapsed < time do

    -- Flip y since negative is up in love
    motion:setVelocity(velocity.x, -velocity.y)

    elapsed = elapsed + coroutine.yield()
    
  end

  motion:setVelocity(0, 0)

end



function AI.moveTo(entity, destination_point, time)

  local transform = entity:getComponent(Transform)
  local motion = entity:getComponent(Motion)

  local current_pos = transform:getPosition()

  local diff = destination_point - current_pos

  local vx = diff.x / time
  local vy = diff.y / time

  local elapsed=0

  while elapsed < time do

    motion:setVelocity(vx, vy)

    elapsed = elapsed + coroutine.yield()
    
  end

  motion:setVelocity(0, 0)

end


function AI.sleep(time)
  local elapsed = 0

  while elapsed < time do

      -- Yield returns extra arguments passed to resume, which
      -- for our system is always DT in this case "dt"

      elapsed = elapsed + coroutine.yield()

  end

end


return AI

