require 'entity.components.transform'
require 'entity.components.motion'
require 'math.vector2'
require 'math.util'

Helpers = require 'game.ai.helpers'


AISteering = {}




function AISteering.seek(entity, target, t)

  local time = t or math.huge

  local entity_motion = entity:getComponent(Motion)

  local acceleration_vector = Vector2(0, 0)

  local elapsed = 0
  local dt = 0

  while elapsed < time do

    Helpers.setVectorTowardOther(acceleration_vector, entity, target)
    Helpers.scaleVectorToMaxAcceleration(acceleration_vector, entity)

    entity_motion:setAcceleration(acceleration_vector.x, acceleration_vector.y)

    elapsed = elapsed + coroutine.yield()

  end


end


function AISteering.pursue(entity, target, t)

  local time = t or math.huge

  local entity_transform = entity:getComponent(Transform)
  local entity_motion = entity:getComponent(Motion)

  local target_transform = target:getComponent(Transform)
  local target_motion = target:getComponent(Motion)


  local elapsed = 0
  local speed = 0
  local distance = 0
  local direction_vector = Vector2(0, 0)
  local acceleration_vector = Vector2(0, 0)
  local target_position = Vector2(0, 0)
  local entity_velocity = nil
  local target_velocity = nil

  local prediction = 0

  while elapsed < time do

    entity_velocity = entity_motion:getVelocity()
    target_velocity = target_motion:getVelocity()

    AIHelpers.setVectorToDistance(direction_vector, entity_transform:getPosition(), target_transform:getPosition())

    distance = direction_vector:len()
    speed = entity_velocity:len()

    if speed > 0 then 
      prediction = distance / speed
    else
      prediction = distance
    end

    target_position:copy(target_transform:getPosition())

    target_position.x = target_position.x + target_velocity.x * prediction
    target_position.y = target_position.y + target_velocity.y * prediction


    AIHelpers.setVectorToDistance(acceleration_vector, entity_transform:getPosition(), target_position)

    Helpers.scaleVectorToMaxAcceleration(acceleration_vector, entity)

    entity_motion:setAcceleration(acceleration_vector.x, acceleration_vector.y)

    elapsed = elapsed + coroutine.yield()

  end


end


function AISteering.evade(entity, target, t)

  local time = t or math.huge

  local entity_transform = entity:getComponent(Transform)
  local entity_motion = entity:getComponent(Motion)

  local target_transform = target:getComponent(Transform)
  local target_motion = target:getComponent(Motion)


  local elapsed = 0
  local speed = 0
  local distance = 0
  local direction_vector = Vector2(0, 0)
  local acceleration_vector = Vector2(0, 0)
  local target_position = Vector2(0, 0)
  local entity_velocity = nil
  local target_velocity = nil

  local prediction = 0

  while elapsed < time do

    entity_velocity = entity_motion:getVelocity()
    target_velocity = target_motion:getVelocity()

    AIHelpers.setVectorToDistance(direction_vector, entity_transform:getPosition(), target_transform:getPosition())

    distance = direction_vector:len()
    speed = entity_velocity:len()

    if speed > 0 then 
      prediction = distance / speed
    else
      prediction = distance
    end

    target_position:copy(target_transform:getPosition())

    target_position.x = target_position.x + target_velocity.x * prediction
    target_position.y = target_position.y + target_velocity.y * prediction


    AIHelpers.setVectorToDistance(acceleration_vector, entity_transform:getPosition(), target_position)

    acceleration_vector:negative()


    Helpers.scaleVectorToMaxAcceleration(acceleration_vector, entity)

    entity_motion:setAcceleration(acceleration_vector.x, acceleration_vector.y)

    elapsed = elapsed + coroutine.yield()

  end


end


function AISteering.flee(entity, target, t)

  local time = t or math.huge

  local entity_motion = entity:getComponent(Motion)

  local acceleration_vector = Vector2(0, 0)

  local elapsed = 0
  local dt = 0

  while elapsed < time do

    -- Accelerate away
    Helpers.setVectorAwayFromOther(acceleration_vector, entity, target)
    Helpers.scaleVectorToMaxAcceleration(acceleration_vector, entity)

    entity_motion:setAcceleration(acceleration_vector.x, acceleration_vector.y)

    elapsed = elapsed + coroutine.yield()

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

  local entity_motion = entity:getComponent(Motion)

  local direction_vector = Vector2(0, 0)

  local elapsed = 0
  local dt = 0


  while elapsed < time do

    dt = coroutine.yield()

    elapsed = elapsed + dt

    -- Accelerate towards

    AIHelpers.setVectorTowardOther(direction_vector, entity, target)
  
    local distance = direction_vector:len()

    local target_velocity = direction_vector

    AIHelpers.scaleVectorToMaxVelocity(target_velocity, entity)

    if distance < target_radius then

      target_velocity:zero()

    elseif distance < slow_radius then

      target_velocity:multiply(distance / slow_radius)

    end
      
    local velocity_diff = target_velocity 
    velocity_diff:subtract(entity_motion:getVelocity())

    local acceleration = velocity_diff

    AIHelpers.scaleVectorToMaxAcceleration(acceleration, entity)

    entity_motion:setAcceleration(acceleration.x, acceleration.y)



  end


end



function AISteering.keepDistance(entity, target, target_radius, slow_radius, t)


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


    AIHelpers.setVectorTowardOther(direction_vector, entity, target)
  
    local distance = direction_vector:len()

    local target_velocity = direction_vector

    AIHelpers.scaleVectorToMaxVelocity(target_velocity, entity)


    if distance < target_radius then

      target_velocity:negative()

    end

    if distance > target_radius - slow_radius or distance > target_radius - slow_radius then

      target_velocity:multiply(distance / slow_radius)

    end
      
    local velocity_diff = target_velocity 
    velocity_diff:subtract(entity_motion:getVelocity())


    local acceleration = velocity_diff

    AIHelpers.scaleVectorToMaxAcceleration(acceleration, entity)

    entity_motion:setAcceleration(acceleration.x, acceleration.y)



  end


end




function AISteering.matchVelocity(entity, target, t)


  local time = t or math.huge

  local entity_transform = entity:getComponent(Transform)
  local target_transform = target:getComponent(Transform)

  local entity_motion = entity:getComponent(Motion)
  local target_motion = target:getComponent(Motion)

  local elapsed = 0
  local dt = 0

  local diff_from_target = Vector2(0, 0)

  while elapsed < time do

    diff_from_target.x = target_motion:getVelocity().x - entity_motion:getVelocity().x
    diff_from_target.y = target_motion:getVelocity().y - entity_motion:getVelocity().y

    diff_from_target:normalize_inplace()
    diff_from_target:multiply(entity_motion.maxAcceleration:len())


    entity_motion:setAcceleration(diff_from_target.x, diff_from_target.y)


    elapsed = elapsed + coroutine.yield()


  end


end





return AISteering

