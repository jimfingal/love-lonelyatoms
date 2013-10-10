




function clamp(value, min, max)
	return math.max(min, math.min(max, value))
end

function math.randomPlusOrMinus()
	local r = math.random()
	if r < 0.5 then return -1 else return 1 end
end

function math.randomBinomial()
	return math.random() - math.random()
end


function math.round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end