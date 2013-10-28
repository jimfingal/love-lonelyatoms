require 'external.middleclass'

Scene = class('Scene')

function Scene:initialize(name, world)
  assert(name, "must have a name")
  self.name = name
  self.world = world
end


function Scene:enter()
    -- setup entities here
    -- print("Calling setup method of scene: " .. self.name)
end

function Scene:draw()
	-- draw all entities
	-- print("Calling draw method of scene: " .. self.name)
end

function Scene:update(dt)
    -- update all entities
    -- print("Calling update method of scene: " .. self.name)

end

function Scene:getName()
    -- update all entities
    return self.name
end
