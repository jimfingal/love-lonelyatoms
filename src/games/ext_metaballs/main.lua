function love.load()
	balls = {{400,300}, {400,300}, {400,300}, {400,300}}
	effect = love.graphics.newPixelEffect(([[

		#define NBALLS %d
		extern vec2[NBALLS] balls;

		float metaball(vec2 x)
		{
			x /= 40.0;
			return 1.0 / (dot(x, x) + .00001);
		}

		vec4 effect(vec4 color, Image tex, vec2 tc, vec2 pc)
		{
			float p = 0.0;
			for (int i = 0; i < NBALLS; ++i)
				p += metaball(pc - balls[i]);
			p = ceil(p * 6.0) / 6.0;
			return vec4(p);
		}
	]]):format(#balls))

	effect:send('balls', unpack(balls))
end

function love.draw()
	love.graphics.setPixelEffect(effect)

	love.graphics.rectangle('fill', 0,0,love.graphics.getWidth(), love.graphics.getHeight())
end

t = 0
function love.update(dt)
	t = t + dt
	balls[1] = {love.mouse.getX(), love.graphics.getHeight() - love.mouse.getY()}
	balls[2] = {math.sin(2*t) * 120 + love.graphics.getWidth()/2, math.cos(t) * 120 + love.graphics.getHeight()/2}
	balls[3] = {math.sin(t) * 120 + love.graphics.getWidth()/2, math.cos(2*t) * 120 + love.graphics.getHeight()/2}
	balls[4] = {
		math.sin(t) * (110 + math.sin(.01*t) * 110)  + love.graphics.getWidth()/2,
		math.cos(t) * (110 + math.sin(.01*t) * 110)  + love.graphics.getHeight()/2,
	}
	effect:send('balls', unpack(balls))
end
