require 'external.middleclass'

BrickConfig = class('BrickConfig')

function BrickConfig:initialize(name, background_length, song_length, background_snd, speed, bricks)
	self.name = name
	self.background_length = background_length
	self.song_length = song_length
	self.background_snd = background_snd
	self.speed = speed
	self.bricks = bricks
end
