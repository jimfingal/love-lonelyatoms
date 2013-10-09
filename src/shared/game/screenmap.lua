require 'external.middleclass'
require 'math.vector2'

ScreenMap = class("ScreenMap")

function ScreenMap:initialize(screen_width, screen_height, xtiles, ytiles)

	self.screen_width = screen_width
	self.screen_height = screen_height
	self.xtiles = xtiles
	self.ytiles = ytiles

	self.tile_width = self.screen_width / self.xtiles
	self.tile_height = self.screen_height / self.ytiles

end

function ScreenMap:getCoordinates(screen_x, screen_y)
	
	return Vector2(math.ceil(screen_x / self.tile_width), math.ceil(screen_y / self.tile_height))

end

function ScreenMap:drawTiles()

	for x = 0, self.screen_width, self.tile_width do 
		for y = 0, self.screen_height, self.tile_height do

			love.graphics.rectangle("line", x, y, self.tile_width, self.tile_height)
		end
	end

end