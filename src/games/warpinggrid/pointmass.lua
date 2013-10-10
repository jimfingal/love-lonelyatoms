require 'external.middleclass'
require 'math.vector3'

PointMass = class('PointMass')


function PointMass:initialize(x, y, z, mass)

    self.invmass = 1/mass
    self.position = Vector3(x, y, z)

    self.velocity = Vector3.ZERO:clone()
    self.acceleration = Vector3.ZERO:clone()

    self.damping = 0.98

end


local _force_buff = Vector3(0, 0, 0)

function PointMass:applyForce(force)

    _force_buff:copy(force)
    _force_buff:multiply(self.invmass)

    self.acceleration:add(_force_buff)

end

function PointMass:increaseDamping(factor)
    self.damping = self.damping  * factor
end

function PointMass:update(dt)

    -- TODO: http://en.wikipedia.org/wiki/Semi-implicit_Euler_method

    self.velocity:add(self.acceleration)
    self.position:add(self.velocity)

    self.acceleration:zero()

    if self.velocity:len2() < 0.001 * 0.001 then
        self.velocity:zero()
    end

    self.velocity:multiply(self.damping)

    self.damping = .98

end