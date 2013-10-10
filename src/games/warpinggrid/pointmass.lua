require 'external.middleclass'
require 'math.vector3'

PointMass = class('PointMass')


function PointMass:initialize(x, y, z, mass)

    self.invmass = 1/mass
    self.position = Vector3(x, y, z)

    self.velocity = Vector3.ZERO:clone()
    self.acceleration = Vector3.ZERO:clone()

    self.damping = 0.98

    self._force_buff = Vector3(0, 0, 0)


end



function PointMass:applyForce(force)

    self._force_buff:copy(force)
    self._force_buff:multiply(self.invmass)

    self.acceleration:add(self._force_buff)

end

function PointMass:increaseDamping(factor)
    self.damping = self.damping  * factor
end

function PointMass:update(dt)

    -- TODO: http://en.wikipedia.org/wiki/Semi-implicit_Euler_method

    self.velocity.x = self.velocity.x + self.acceleration.x 
    self.velocity.y = self.velocity.y + self.acceleration.y 
    self.velocity.z = self.velocity.z + self.acceleration.z

    self.position.x = self.position.x + self.velocity.x 
    self.position.y = self.position.y + self.velocity.y 
    self.position.z = self.position.z + self.velocity.z


    self.acceleration.x = 0
    self.acceleration.y = 0
    self.acceleration.z = 0

    if self.velocity:len2() < 0.001 * 0.001 then
        self.velocity.x = 0
        self.velocity.y = 0
        self.velocity.z = 0    
    end

    self.velocity.x = self.velocity.x * self.damping
    self.velocity.y = self.velocity.y * self.damping
    self.velocity.z = self.velocity.z * self.damping

    self.damping = .98

end