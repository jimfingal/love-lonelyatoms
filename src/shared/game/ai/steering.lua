require 'entity.components.transform'
require 'entity.components.motion'
require 'math.vector2'
require 'math.util'
require 'external.middleclass'

Helpers = require 'game.ai.helpers'


Steering = class('Steering', PoolSource)

function Steering:initialize(target_vector, acceleration, rotation)
  self.target_vector = target_vector or Vector2(0, 0)
  self.acceleration = acceleration or 0
  self.rotation = rotation or 0

  self._buffer = Vector2(0, 0)

end

function Steering:clear()
  self.target_vector:zero()
  self._buffer:zero()
  self.acceleration = 0
  self.rotation = 0
end


AISteering = {}

local pos = function (entity) return entity:getComponent(Transform):getPosition() end
local maxAcceleration = function (entity) return entity:getComponent(Motion).maxAcceleration:len() end

function AISteering.steer(steeringFunction, entity, ...)

  local elapsed = 0

  local steering = Steering()

  local entity_transform = entity:getComponent(Transform)
  local entity_motion = entity:getComponent(Motion)

  local target_vector = nil

  while true do

    steeringFunction(steering, entity, ...)

    target_vector = steering.target_vector
    target_vector:scaleTo(steering.acceleration)
    entity_motion:setAcceleration(target_vector.x, target_vector.y)

    entity_transform:rotateTo(steering.rotation)

    elapsed = elapsed + coroutine.yield()

  end

end



function AISteering.seek(steering, entity, target)

  steering:clear()

  steering.target_vector:setToDifference(pos(entity), pos(target))
  steering.acceleration = maxAcceleration(entity)

end


function AISteering.pursue(steering, entity, target)

  steering:clear()

  local entity_transform = entity:getComponent(Transform)
  local entity_motion = entity:getComponent(Motion)

  local target_transform = target:getComponent(Transform)
  local target_motion = target:getComponent(Motion)


  steering._buffer:setToDifference(pos(entity), pos(target))
  local distance = steering._buffer:len()  

  local speed = entity_motion:getVelocity():len()

  local prediction = distance

  if speed > 0 then 
    prediction = distance / speed
  end

  -- Set target position to where target is going
  local new_target = steering._buffer
  
  local target_velocity = target_motion:getVelocity()
  
  new_target:copy(target_transform:getPosition())
  new_target.x = new_target.x + target_velocity.x * prediction
  new_target.y = new_target.y + target_velocity.y * prediction


  -- Seek this new point
  steering.target_vector:setToDifference(pos(entity), new_target)
  steering.acceleration = maxAcceleration(entity)


end



function AISteering.arrive(steering, entity, target, target_radius, slow_radius)


  AISteering.seek(steering, entity, target)

  local entity_motion = entity:getComponent(Motion)

  local distance = steering.target_vector:len()

  local target_norm_x, target_norm_y = steering.target_vector:normalized_values()

  local target_speed = entity_motion.maxVelocity:len()

  if distance < target_radius then

      target_speed = 0

  elseif distance < slow_radius then

      target_speed = target_speed * (distance / slow_radius)

  end
  
  -- Target Velocity
  local target_velocity = steering.target_vector
  target_velocity:normalize_inplace()
  target_velocity:multiply(target_speed)


  -- Accelerate to get to the target velocity vector
  steering.target_vector:subtract(entity_motion:getVelocity())


end





function AISteering.evade(steering, entity, target)

    AISteering.pursue(steering, entity, target)
    steering.target_vector:negative()

end


function AISteering.flee(steering, entity, target)

  AISteering.seek(steering, entity, target)
  steering.target_vector:negative()

end



function AISteering.wander(steering, entity, target_speed, max_rotation)

  steering:clear()

  local rotation = entity:getComponent(Transform):getRotation()
  local rotation_delta = math.randomBinomial() * max_rotation

  steering.rotation = rotation + rotation_delta

  local current_speed = entity:getComponent(Motion):getVelocity():len()
  local speed_diff = target_speed - current_speed

  steering.target_vector = Vector2.fromTheta(steering.rotation)
  steering.target_vector:multiply(speed_diff)

  steering.acceleration = maxAcceleration(entity)


end



function AISteering.keepTargetDistance(steering, entity, target, target_radius, slow_radius)


  AISteering.seek(steering, entity, target)

  local entity_motion = entity:getComponent(Motion)

  local distance = steering.target_vector:len()

  local target_norm_x, target_norm_y = steering.target_vector:normalized_values()

  local target_speed = entity_motion.maxVelocity:len()

  if distance < target_radius then

      target_speed = -target_speed

  end

  if distance > target_radius - slow_radius or distance > target_radius - slow_radius then

      target_speed = target_speed * (distance / slow_radius)

  end
  
  -- Target Velocity
  local target_velocity = steering.target_vector
  target_velocity:normalize_inplace()
  target_velocity:multiply(target_speed)


  -- Accelerate to get to the target velocity vector
  steering.target_vector:subtract(entity_motion:getVelocity())


end






function AISteering.orbit(steering, entity, target, target_orbit, target_speed)

  steering:clear()

  local tolerance = 3

  local half_pi = math.pi / 2
  local quarter_pi = math.pi / 4


  steering.target_vector:setToDifference(pos(entity), pos(target))

  local distance = steering.target_vector:len()

  steering.target_vector:normalize_inplace()
  steering.target_vector:rotate(half_pi)

  -- Rotate inwards
  if distance > target_orbit + tolerance then
      steering.target_vector:rotate(-quarter_pi)
  elseif distance < target_orbit - tolerance then
      steering.target_vector:rotate(quarter_pi)
  end

  local current_speed = entity:getComponent(Motion):getVelocity():len()

  local speed_diff = target_speed - current_speed


  steering.target_vector:multiply(speed_diff)

  steering.rotation = steering.target_vector:toTheta()
  steering.acceleration = maxAcceleration(entity)


end








function AISteering.matchVelocity(steering, entity, target)


  local entity_motion = entity:getComponent(Motion)
  local target_motion = target:getComponent(Motion)

  steering.target_vector.x = target_motion:getVelocity().x - entity_motion:getVelocity().x
  steering.target_vector.y = target_motion:getVelocity().y - entity_motion:getVelocity().y

  steering.acceleration = maxAcceleration(entity)


end





return AISteering

