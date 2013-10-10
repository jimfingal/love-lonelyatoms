require 'entity.components.transform'
require 'entity.components.motion'
require 'math.vector2'

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


function AISteering.wander(entity, target, acceleration_per_sec, time)

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





return AISteering

