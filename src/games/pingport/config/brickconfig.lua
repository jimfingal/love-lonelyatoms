require 'engine.spritegroup'
require 'collections.list'
require 'engine.color'
require 'sprites.brick'
require 'assets.assets'


BrickLoader = {}


local c1 = 205
local c2 = 147
local c3 = 176
    
local colors = List()

colors:append(Color:new(c1, c2, c2))
colors:append(Color:new(c1, c2, c3))
colors:append(Color:new(c1, c2, c1))
colors:append(Color:new(c3, c2, c1))
colors:append(Color:new(c2, c2, c1))
colors:append(Color:new(c2, c3, c1))
colors:append(Color:new(c2, c1, c1))
colors:append(Color:new(c2, c1, c3))
colors:append(Color:new(c2, c1, c2))
colors:append(Color:new(c3, c1, c2))


BrickLoader.load_bricks = function(asset_manager, brick_source)
	
	local bricks = SpriteGroup('bricks', true, true)

	if not brick_source then 

		background = "wereinthistogether_background.mp3"

		asset_manager:loadSound(Assets.BACKGROUND_SOUND, background)

		for y = 0, 20, 20 do
--		for y = 0, 340, 20 do

			local x_start = 0
			local x_end = 700

			if y > 0 and y % 40 == 20 then 
				x_start = 50
				x_end = 650
			end

			for x=x_start, x_end, 100 do

				local random = math.random(1, colors:size())

				local this_color = colors:memberAt(random)

				asset_manager:loadSound("wereinthistogether1.mp3", "wereinthistogether1.mp3")

				local brick = Brick(x .. y, x, y, 100, 20, this_color.r, this_color.g, this_color.b, asset_manager:getSound("wereinthistogether1.mp3"))

				bricks:add(brick)

			end
		end

	else
		config = require '01LightningRiskedItAll'

	end

	return bricks

end

return BrickLoade