require 'entity.components.transform'
require 'entity.components.motion'
require 'math.vector2'
require 'math.util'

AISteering = {}


function AISteering.seek(entity, target, acceleration_per_sec, t)


  local time = t or math.huge

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

function AISteering.flee(entity, target, acceleration_per_sec, t)

  local time = t or math.huge

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

    direction_vector:copy(entity_transform:getPosition())
    direction_vector:subtract(target_transform:getPosition())

    direction_vector:normalize_inplace()

    entity_motion:accelerate(direction_vector.x * acceleration_per_sec * dt, direction_vector.y * acceleration_per_sec * dt)


  end


end


function AISteering.wander(entity, acceleration, max_rotation, t)

  local time = t or math.huge

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

function AISteering.orbit(entity, target, target_orbit, speed, t)

  local time = t or math.huge

  local entity_transform = entity:getComponent(Transform)
  local entity_motion = entity:getComponent(Motion)

  local target_transform = target:getComponent(Transform)

  local distance_vector = Vector2(0, 0)

  local direction_vector = Vector2(0, 0)

  local elapsed = 0

  local half_pi = math.pi / 2
  local quarter_pi = math.pi / 4

  while elapsed < time do


    distance_vector:copy(target_transform:getPosition())
    distance_vector:subtract(entity_transform:getPosition())
 
    direction_vector:copy(distance_vector)
    direction_vector:normalize_inplace()
    direction_vector:rotate(half_pi)

    -- Rotate inwards
    if distance_vector:len() > target_orbit then
        direction_vector:rotate(-quarter_pi)
    end

    direction_vector:multiply(speed)


    entity_motion:setVelocity(direction_vector.x, direction_vector.y)

    elapsed = elapsed + coroutine.yield()
  
  end


end





function AISteering.arrive(entity, target, target_radius, slow_radius, t)


  local time = t or math.huge

  local entity_transform = entity:getComponent(Transform)
  local target_transform = target:getComponent(Transform)

  local entity_motion = entity:getComponent(Motion)

  local direction_vector = Vector2(0, 0)

  local elapsed = 0
  local dt = 0

  local max_velocity = entity_motion.maxVelocity:len()

  while elapsed < time do

    dt = coroutine.yield()

    elapsed = elapsed + dt

    -- Accelerate towards

    direction_vector:copy(target_transform:getPosition())
    direction_vector:subtract(entity_transform:getPosition())

    local distance = direction_vector:len()

    direction_vector:normalize_inplace()

    local target_velocity = direction_vector * max_velocity

    if distance < target_radius then

      target_velocity:zero()

    elseif distance < slow_radius then

      target_velocity = target_velocity * (distance / slow_radius)

    end
      
    local velocity_diff = target_velocity - entity_motion:getVelocity()

    velocity_diff:normalize_inplace()

    local acceleration = velocity_diff * entity_motion.maxAcceleration:len()


    entity_motion:setAcceleration(acceleration.x, acceleration.y)



  end


end




return AISteering

