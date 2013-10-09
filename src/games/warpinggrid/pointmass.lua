require 'external.middleclass'

WaterParticle = class('WaterParticle', Particle)


function WaterParticle:initialize()

end

--[[

private class PointMass
{
    public Vector3 Position;
    public Vector3 Velocity;
    public float InverseMass;
 
    private Vector3 acceleration;
    private float damping = 0.98f;
 
    public PointMass(Vector3 position, float invMass)
    {
        Position = position;
        InverseMass = invMass;
    }
 
    public void ApplyForce(Vector3 force)
    {
        acceleration += force * InverseMass;
    }
 
    public void IncreaseDamping(float factor)
    {
        damping *= factor;
    }
 
    public void Update()
    {
        Velocity += acceleration;
        Position += Velocity;
        acceleration = Vector3.Zero;
        if (Velocity.LengthSquared() < 0.001f * 0.001f)
            Velocity = Vector3.Zero;
 
        Velocity *= damping;
        damping = 0.98f;
    }
}


]]