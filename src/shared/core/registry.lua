require 'external.middleclass'

Registry = class("Registry")

function Registry:initialize()

	self.registry = {}

end

function Registry:removeEntry(id)

	self.registry[id] = nil

end

function Registry:clearEntries()

	self.registry = {}

end


function Registry:addEntry(id, entry)

	self.registry[id] = entry

end

function Registry:members()

	return ipairs(self.registry)

end