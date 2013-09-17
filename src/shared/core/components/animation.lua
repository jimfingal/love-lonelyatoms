-- Basics inspired by https://github.com/kikito/anim8/blob/master/anim8.lua
-- Which are:
-- anim8 v2.0.0 - 2013-04
-- Copyright (c) 2011 Enrique García Cota
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


require 'external.middleclass'
require 'collections.list'

Animation = class("Animation", Component)

Animation.PAUSED = "paused"
Animation.PLAYING = "playing"

local function parseDurations(durations)

	local frame_borders = {0}
	local time = 0

	for i = 1, #durations do
		time = time + durations[i]
    	frame_borders[i+1] = time
	end

	return frame_borders, time
end


function Animation:initialize(durations, loop)

	self.durations = durations
	self.loop = loop

	self.frame_borders, self.total_time = parseDurations(durations)

	self.timer = 0
	self.total_runtime = 0
	self.position = 1

	self.status = Animation.PAUSED
end


function Animation:pause()
	self.status = Animation.PAUSED
end

function Animation:pauseAtStart()
  self.position = 1
  self.timer = 0
  self:pause()
end

function Animation:play()
	self.status = Animation.PLAYING
end


TextAnimation = class("TextAnimation", Animation)

function TextAnimation:initialize(text, letter_duration, loop, new_letter_callback)

	self.text = text
	self.new_letter_callback = new_letter_callback
	self.last_position = 1

	local text_length = string.len(text)
	local durations = {}

	for i=1, text_length do
		durations[i] = letter_duration
	end

	Animation.initialize(self, durations, loop)

end

function TextAnimation:afterUpdate(dt)

	if self.position ~= self.last_position and self.new_letter_callback then
		self:new_letter_callback()
		self.last_position = self.position + 0
	end

end

function TextAnimation:draw(x, y)

	love.graphics.print(string.sub(self.text, 1, self.position), x, y)

end

