keys = {}
this_frame_keys = {}

object_kinds = {"player", "enemy_bullet"}
colors = {player = {255, 140, 0, 255},
            enemy_bullet = {255, 255, 255, 255}}
for a,b in ipairs(object_kinds) do object_kinds[b]=a end

pi              = 3.141592653589793238462643383279502
degrees         = 0.01745329251994329576923690768489
tau             = 6.283185307179586476925286766559
facing_right    = 0.0
facing_up       = 1.5707963267948966192313216916398
facing_left     = 3.141592653589793238462643383279502
facing_down     = 4.7123889803846898576939650749193

sin     = math.sin
cos     = math.cos
atan2   = math.atan2
sqrt    = math.sqrt
min     = math.min
max     = math.max
abs     = math.abs
floor   = math.floor
ceil    = math.ceil
random  = math.random

function uniformly(t)
    return t[random(#t)]
end

gfx_q = Queue()

-- All of these functions assume that "Cartesian" means "screen space."
function get_polar(x, y)
	return sqrt(x*x+y*y), atan2(-y,x)
end

function get_theta(x, y)
	return atan2(-y,x)
end

function get_cartesian(r, theta)
	return r*cos(theta), -r*sin(theta)
end

function get_x_from_polar(r, theta)
	return r*cos(theta)
end

function get_y_from_polar(r, theta)
	return -r*sin(theta)
end
