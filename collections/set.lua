Set = {}
local set_mt = {}

function Set.new (list)
	local set = {}
	setmetatable(set, set_mt)
	for _, l in ipairs(list) do 
		set[l] = true 
	end
	return set
end

function Set.add (set, element)
	set[element] = true
	return set
end

function Set.remove(set, element)
	set[element] = nil
	return set
end

function Set.contains(set, element)
	return set[element]
end

function Set.tostring(set)
	local l = {} -- List of elements
	for e in pairs(set) do
		l[#l + 1] = e
	end
	return "{" .. table.concat(l, ", ") .. "}"
end

function Set.print(set)
	print(Set.tostring(set))
end

-- Metatable stuff
set_mt.__tostring = Set.tostring

return Set