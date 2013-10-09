require 'external.middleclass'
require 'collections.list'
require 'collections.set'

-- Contains a list that represents a CNF query for entities.
-- Each item in the list is a set. Each set contains ORs, and each set is AND'ed
-- Together.

EntityQuery = class('EntityQuery')

function EntityQuery:initialize()
	self.cnf_query = List()
	return self
end

function EntityQuery:addOrSet(...)
	local or_set = Set()
	for i,v in ipairs(arg) do 
		or_set:add(v)
	end

	self.cnf_query:append(or_set)
	return self
end

function EntityQuery:getQuery()
	return self.cnf_query
end


function EntityQuery:clear()
	self.cnf_query = List()
	return self
end

function EntityQuery:__tostring()
	local s = "EntityQuery: " 

	if self.cnf_query:size() > 0 then
		local first = true
		for i, or_set in self.cnf_query:members() do

			if first then
				first = false
			else
				s = s .. " AND "
			end
			s = s .. "[ "
			for item in or_set:members() do
				s = s .. tostring(item) .. "; "
			end
			s = s .. "] "
		end
	else
		s = s .. "[ (Empty Query) ]"
	end
	return s
end


