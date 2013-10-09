require 'external.middleclass'
require 'math.vector3'
require 'pointmass'

Spring = class('Spring')


function Spring:initialize(pointmass1, pointmass2, stiffness, damping)

    self.pointmass1 = pointmass1
    self.pointmass2 = pointmass2
    self.stiffness = stiffness
    self.damping = damping
    self.target_length = Vector3.distance(pointmass1:getPosition(), pointmass2:getPosition())

    self._point_buffer = Vector3(0, 0, 0)
    self._velocity_buffer = Vector3(0, 0, 0)

end

function Spring:update()

--    local x = self.pointmass1:getPosition() - self.pointmass2:getPosition()

    self._point_buffer:copy(self.pointmass1:getPosition())
    self._point_buffer:subtract(self.pointmass2:getPosition())

    local x = self._point_buffer

    local length = x:len()

    -- These springs can only pull, not push

    if length <= self.target_length then
        return
    end
    

    x:divide(length)
    x:multiply(length - self.target_length)

    self._velocity_buffer:copy(self.pointmass2:getVelocity())
    self._velocity_buffer:subtract(self.pointmass1:getVelocity())

    local dv = self._velocity_buffer

--  local force = x * self.stiffness - (dv * self.damping)

    x:multiply(self.stiffness)
    dv:multiply(self.damping)
    x:subtract(dv)

    local force = x
 
    self.pointmass2:applyForce(force)

    force:multiply(-1)
    self.pointmass1:applyForce(force)


end

