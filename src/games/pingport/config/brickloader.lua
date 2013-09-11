require 'external.middleclass'
require 'config.brickconfig'
require 'core.group'
require 'collections.list'
require 'core.color'
require 'sprites.brick'
require 'assets.assets'
require 'helpers.tablehelper'

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


local BrickLoaderClass = class('BrickLoaderClass')

BrickLoader = BrickLoaderClass()


function BrickLoaderClass:initialize()
	-- foo
end

function BrickLoaderClass:load_bricks(asset_manager, brick_source)
	
	local bricks = Group(true, true)

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

		required = 'assets.spritemaps.' .. brick_source

		config = require(required)

		asset_manager:loadSound(config.background_snd, config.background_snd)

		for _, brickinfo in ipairs(config.bricks) do

			asset_manager:loadSound(brickinfo.snd, brickinfo.snd)

			local brick = Brick(brickinfo.x, 
								brickinfo.y, 
								brickinfo.width, 
								brickinfo.height, 
								brickinfo.r, 
								brickinfo.g, 
								brickinfo.b, 
								asset_manager:getSound(brickinfo.snd))

			bricks:add(brick)

		end


		local bc = BrickConfig(config.name, 
							config.background_length, 
							config.song_length, 
							asset_manager:getSound(config.background_snd), 
							config.speed,
							bricks)

		return bc
	end

	return bricks

end
