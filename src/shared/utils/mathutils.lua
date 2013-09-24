

function clamp(value, min, max)
	return math.max(min, math.min(max, value))
end

function math.randomPlusOrMinus()
	local r = math.random()
	if r < 0.5 then return -1 else return 1 end
end