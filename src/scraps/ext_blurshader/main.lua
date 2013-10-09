-- note that this might not be the most efficient way to blur,
-- a better way might be to scale down the canvases and
-- apply the final blur to the main canvas

function love.load()
	local xres, yres = 1280, 720
	love.graphics.setMode(xres, yres, false, false, 0)
	
	img = love.graphics.newImage("cross_color.png")
	
	blur_vertical = love.graphics.newPixelEffect[[
		extern number rt_h = 600.0; // render target height
		
		extern number intensity = 1.0;

		const number offset[3] = number[](0.0, 1.3846153846, 3.2307692308);
		const number weight[3] = number[](0.2270270270, 0.3162162162, 0.0702702703);
		
		vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
		{
			vec4 texcolor = Texel(texture, texture_coords);
			vec3 tc = texcolor.rgb * weight[0];
			
			tc += Texel(texture, texture_coords + intensity * vec2(0.0, offset[1])/rt_h).rgb * weight[1];
			tc += Texel(texture, texture_coords - intensity * vec2(0.0, offset[1])/rt_h).rgb * weight[1];
			
			tc += Texel(texture, texture_coords + intensity * vec2(0.0, offset[2])/rt_h).rgb * weight[2];
			tc += Texel(texture, texture_coords - intensity * vec2(0.0, offset[2])/rt_h).rgb * weight[2];
			
			return color * vec4(tc, texcolor.a);
		}
	]]
	blur_vertical:send("rt_h", yres)
	
	blur_horizontal = love.graphics.newPixelEffect[[
		extern number rt_w = 800.0; // render target width
		
		extern number intensity = 1.0;

		const number offset[3] = number[](0.0, 1.3846153846, 3.2307692308);
		const number weight[3] = number[](0.2270270270, 0.3162162162, 0.0702702703);

		vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
		{
			vec4 texcolor = Texel(texture, texture_coords);
			vec3 tc = texcolor.rgb * weight[0];
			
			tc += Texel(texture, texture_coords + intensity * vec2(offset[1], 0.0)/rt_w).rgb * weight[1];
			tc += Texel(texture, texture_coords - intensity * vec2(offset[1], 0.0)/rt_w).rgb * weight[1];
			
			tc += Texel(texture, texture_coords + intensity * vec2(offset[2], 0.0)/rt_w).rgb * weight[2];
			tc += Texel(texture, texture_coords - intensity * vec2(offset[2], 0.0)/rt_w).rgb * weight[2];
			
			return color * vec4(tc, texcolor.a);
		}
	]]
	blur_horizontal:send("rt_w", xres)
	
	canvases = {
		love.graphics.newCanvas(),
		love.graphics.newCanvas(),
	}
	
	blur = true
end

function love.keypressed(key)
	if key == " " then
		blur = not blur
	end
end

local time = 0
function love.update(dt)
	time = time + dt
	local intensity = (math.sin(time) + 1) * 0.5
	blur_vertical:send("intensity", (intensity))
	blur_horizontal:send("intensity", (intensity))
end

local fps = 0

function love.draw()
	for i,v in ipairs(canvases) do v:clear() end
	
	if blur then love.graphics.setCanvas(canvases[1]) end
	
	for x=0, love.graphics.getWidth(), img:getWidth()/2 do
		for y=0, love.graphics.getHeight(), img:getHeight()/2 do
			love.graphics.draw(img, x, y, 0, 0.4, 0.4)
		end
	end
	
	if blur then
		love.graphics.setCanvas(canvases[2])
		love.graphics.setPixelEffect(blur_vertical)
		
		love.graphics.draw(canvases[1], 0, 0)
		
		love.graphics.setCanvas()
		love.graphics.setPixelEffect(blur_horizontal)
		
		love.graphics.draw(canvases[2], 0, 0)
		
		love.graphics.setPixelEffect()
	end
	
	newfps = love.timer.getFPS()
	if newfps ~= fps then
		fps = newfps
		love.graphics.setCaption(string.format("frame time: %.2fms (%d fps). Blur %s", 1000/fps, fps, blur and "ON" or "OFF"))
	end
end
