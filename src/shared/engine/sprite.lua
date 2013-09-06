require 'class.middleclass'
require 'engine.gameobject'
require 'engine.transform'

Sprite = class('Sprite', GameObject)


function Sprite:initialize(name, x, y, width, height)
	GameObject.initialize(self, name)

	self.transform = Transform(x, y)
	
	-- Property: width
	-- Width in pixels.
	self.width = width or 0

	-- Property: height
	-- Height in pixels.
	self.height = height or 0


	self.img = nil

	self.fill = {0, 0, 0}

	--[[
	-- Property: flipX
	-- If set to true, then the sprite will draw flipped horizontally.
	self.flipX = false

	-- Property: flipY
	-- If set to true, then the sprite will draw flipped vertically.
	self.flipY = false

	-- Property: alpha
	-- This affects the transparency at which the sprite is drawn onscreen. 1 is fully
	-- opaque 0 is completely transparent.
	alpha = 1

	-- Property: tint
	-- This tints the sprite a color onscreen. This goes in RGB order each number affects
	-- how that particular channel is drawn. e.g. to draw the sprite in red only, set tint to
	-- { 1, 0, 0 }.
	tint = { 1, 1, 1 }
	--]]

end

function Sprite:die()
	self.active = false
	self.visible = false
end

function Sprite:revive()
	self.active = true
	self.visible = true
end

function Sprite:setImg(img)
	self.img = img
end

function Sprite:setFill(r, g, b)
	self.fill = {r, g, b}
end


function Sprite:startFrame(dt)
	-- Overrided by subclasses
end

function Sprite:update(dt)
	-- Overrided by subclasses
end

function Sprite:endFrame(dt)
	-- Overrided by subclasses
end



function Sprite:draw()

	if self.img then
		love.graphics.draw(self.img, self.transform.position.x, self.transform.position.y, self.width, self.height)
	else
		love.graphics.setColor(self.fill[1], self.fill[2], self.fill[3])
		love.graphics.rectangle("fill", self.transform.position.x, self.transform.position.y, self.width, self.height)
	end
end
