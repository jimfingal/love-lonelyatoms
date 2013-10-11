require 'external.middleclass'
require 'math.vector3'
require 'game.warpinggrid.pointmass'

Spring = class('Spring')


function Spring:initialize(pointmass1, pointmass2, stiffness, damping)

    self.pointmass1 = pointmass1
    self.pointmass2 = pointmass2
    self.stiffness = stiffness
    self.damping = damping
    self.target_length = Vector3.distance(pointmass1.position, pointmass2.position)

    self._point_buffer = Vector3(0, 0, 0)
    self._velocity_buffer = Vector3(0, 0, 0)

end

function Spring:update()

--    local x = self.pointmass1:getPosition() - self.pointmass2:getPosition()

    self._point_buffer.x = self.pointmass1.position.x - self.pointmass2.position.x
    self._point_buffer.y = self.pointmass1.position.y - self.pointmass2.position.y
    self._point_buffer.z = self.pointmass1.position.z - self.pointmass2.position.z

    
    local x = self._point_buffer

    local length = x:len()

    -- These springs can only pull, not push

    if length <= self.target_length then
        return
    end
    

    x:divide(length)
    x:multiply(length - self.target_length)


    self._velocity_buffer.x = self.pointmass2.velocity.x - self.pointmass1.velocity.x
    self._velocity_buffer.y = self.pointmass2.velocity.y - self.pointmass1.velocity.y
    self._velocity_buffer.z = self.pointmass2.velocity.z - self.pointmass1.velocity.z

    local dv = self._velocity_buffer

--  local force = x * self.stiffness - (dv * self.damping)

    x.x = x.x * self.stiffness - (dv.x * self.damping)
    x.y = x.y * self.stiffness - (dv.y * self.damping)
    x.z = x.z * self.stiffness - (dv.z * self.damping)


    local force = x
 
    self.pointmass2:applyForce(force)

    force.x = force.x * -1
    force.y = force.y * -1
    force.z = force.z * -1

    self.pointmass1:applyForce(force)


end

