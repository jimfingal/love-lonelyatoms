-- Basics inspired by https://github.com/kikito/anim8/blob/master/anim8.lua
-- Which are:
-- anim8 v2.0.0 - 2013-04
-- Copyright (c) 2011 Enrique García Cota
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


require 'external.middleclass'
require 'collections.list'

Animation = class("Animation")

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

local function getFrameIndex(frame_borders, timer)

	-- Should start out on the first frame if just starting
	if timer == 0 then
		return 1
	end

	for index, border in ipairs(frame_borders) do
		if timer <= border then
			frame_index = index - 1
			return frame_index
		end
	end

	-- If we're beyond the last border, we should be in the last position.
	return #frame_borders - 1

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


function Animation:update(dt)

	if self.status ~= Animation.PLAYING then 
		return 
	end

	self.timer = self.timer + dt

	self.total_runtime = self.total_runtime + dt


	if self.timer >= self.total_time then

		if self.loop then
			self.timer = self.timer % self.total_time
		else
			self.status = Animation.PAUSED
		end
	end

	self.position = getFrameIndex(self.frame_borders, self.timer)



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

	local text_length = string.len(text)
	local durations = {}

	for i=1, text_length do
		durations[i] = letter_duration
	end

	Animation.initialize(self, durations, loop)

end

function TextAnimation:draw(x, y)

	love.graphics.print(string.sub(self.text, 1, self.position), x, y)

end

