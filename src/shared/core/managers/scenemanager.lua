require 'external.middleclass'

SceneManager = class("SceneManager")

function SceneManager:initialize(world)
	self.last_scene = nil
	self.current_scene = nil
	self.current_scene_name = nil
	self.scenes = {}
	self.world = world
end


function SceneManager:registerScene(this_scene)
	assert(this_scene, "Missing argument: GameScene to register")
	self.scenes[this_scene:getName()] = this_scene
end

function SceneManager:printscenes()
	local l = {}
	for e in pairs(self.scenes) do
		l[#l + 1] = e
	end
	print("{" .. table.concat(l, ", ") .. "}")
end

function SceneManager:changeScene(to_name, ...)
	assert(to_name, "Missing argument: Gamescene to switch to")
	assert(self:sceneExists(to_name), "scene must exist")
	self.last_scene = self.current_scene
	self.current_scene = self.scenes[to_name]
	self.current_scene_name = to_name
	self.current_scene:enter(...)
	return to
end

function SceneManager:sceneExists(name)
	return self.scenes[name]
end

function SceneManager:currentScene()
	return self.current_scene
end

function SceneManager:currentSceneName()
	return self.current_scene_name
end

-- Callbacks to forward

function SceneManager:update(dt)
	self.current_scene:update(dt)
end

function SceneManager:draw()
	self.current_scene:draw()
end