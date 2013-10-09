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

	if self.fonts[key] then
		return -- Don't double-load
	end

	if not font_size then
		font_size = self.default_font_size
	end

	local font = love.graphics.newFont(self.font_path .. font_name, font_size)
	
	self.fonts[key] = font

	return font
end

function AssetManager:getFont(key)
	assert(self.fonts[key], "Font must be registered")
	return self.fonts[key]
end


function AssetManager:loadSound(key, sound_name)
	assert(key, "Missing argument: name of sound")
	assert(sound_name, "Missing argument: sound to register")

	if self.sounds[key] then
		return self.sounds[key] -- Don't double-load
	end

	local snd  = love.audio.newSource(self.sound_path .. sound_name, 'static')
	
	self.sounds[key] = snd

	return snd

end

function AssetManager:getSound(key)
	assert(self.sounds[key], "sound must be registered")
	return self.sounds[key]
end


function AssetManager:loadImage(key, image_name)
	assert(key, "Missing argument: key name of image")
	assert(image_name, "Missing argument: image to register")

	if self.images[key] then
		return self.images[key] -- Don't double-load
	end

	local img  = love.graphics.newImage(self.image_path .. image_name)
	img:setFilter("nearest", "linear")
	
	self.images[key] = img

	return img

end

function AssetManager:getImage(key)
	assert(self.images[key], "image must be registered")
	return self.images[key]
end


