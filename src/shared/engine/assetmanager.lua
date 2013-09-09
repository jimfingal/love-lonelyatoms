require 'external.middleclass'

AssetManager = class("AssetManager")

function AssetManager:initialize(font_path, sound_path, image_path)
	self.fonts = {}
	self.sounds = {}
	self.images = {}

	assert(font_path, "Must have default path to find fonts")
	assert(sound_path, "Must have default path to find fonts")
	assert(image_path, "Must have default path to find fonts")

	self.font_path = font_path
	self.sound_path = sound_path
	self.image_path = image_path

	self.default_font_size = 12

end


function AssetManager:loadFont(key, font_name, font_size)
	assert(key, "Missing argument: name of font")
	assert(font_name, "Missing argument: font to register")

	if not font_size then
		font_size = self.default_font_size
	end

	local font = love.graphics.newFont(self.font_path .. font_name, font_size)
	
	self.fonts[key] = font
end

function AssetManager:getFont(name)
	assert(self.fonts[name], "Font must be registered")
	return self.fonts[name]
end


function AssetManager:loadSound(key, sound_name)
	assert(key, "Missing argument: name of sound")
	assert(sound_name, "Missing argument: sound to register")

	local snd  = love.audio.newSource(self.sound_path .. sound_name)
	
	self.sounds[key] = snd
end

function AssetManager:getSound(name)
	assert(self.sounds[name], "sound must be registered")
	return self.sounds[name]
end


