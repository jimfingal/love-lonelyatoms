require 'entity.components.transform'
require 'entity.components.motion'
require 'math.vector2'
require 'math.util'

AISteering = {}


function AISteering.seek(entity, target, acceleration_per_sec, time)

  local entity_transform = entity:getComponent(Transform)
  local target_transform = target:getComponent(Transform)

  local entity_motion = entity:getComponent(Motion)

  local direction_vector = Vector2(0, 0)

  local elapsed = 0
  local dt = 0

  while elapsed < time do

    dt = coroutine.yield()

    elapsed = elapsed + dt

    -- Accelerate towards

    direction_vector:copy(target_transform:getPosition())
    direction_vector:subtract(entity_transform:getPosition())

    direction_vector:normalize_inplace()

    entity_motion:accelerate(direction_vector.x * acceleration_per_sec * dt, direction_vector.y * acceleration_per_sec * dt)


  end


end


function AISteering.wander(entity, acceleration, max_rotation, time)

  local entity_transform = entity:getComponent(Transform)
  local entity_motion = entity:getComponent(Motion)

  local rotation = entity_transform:getRotation()


  local elapsed = 0

  while elapsed < time do

    local dt = coroutine.yield()

 
    entity_transform:rotate(math.randomBinomial() * max_rotation)

    local direction_vector = Vector2.fromTheta(entity_transform:getRotation())
    local da = direction_vector * acceleration * dt 

    entity_motion:accelerate(da.x, da.y)

    elapsed = elapsed + dt
  
  end


end





return AISteering

