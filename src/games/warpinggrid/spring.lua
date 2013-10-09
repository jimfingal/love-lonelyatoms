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

end

function Spring:update()

    local x = self.pointmass1:getPosition() - self.pointmass2:getPosition()

    local length = x:len()

    -- These springs can only pull, not push
    if length <= self.target_length then
        return
    end
     
    x = (x / length) * (length - self.target_length)

    local dv =  self.pointmass2:getVelocity() -  self.pointmass1:getVelocity()

    local force = self.stiffness * x - dv * self.damping
 
    self.pointmass1:applyForce(-force)
    self.pointmass2:applyForce(force)

end

