require 'external.middleclass'
require 'engine.gameobject'
require 'engine.transform'
require 'engine.spritegroup'
require 'engine.color'


Sprite = class('Sprite', GameObject)


function Sprite:initialize(name, shape, collider)

	GameObject.initialize(self, name)

	self.shape = shape

	self.collider = collider
	
	-- Property: width
	-- Width in pixels.
	self.width = width or 0

	-- Property: height
	-- Height in pixels.
	self.height = height or 0


	self.img = nil

	self.fill = Color(0, 0, 0)

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

function Sprite:moveTo(x, y)
	self.shape:moveTo(x, y)
	if self.collider then 
		self.collider:moveTo(x, y) 
	end
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

function Sprite:setFill(r, g, b, a)
	self.fill = Color(r, g, b, a)
end

function Sprite:processInput(dt, input)
	-- Overrided by subclasses
end

function Sprite:update(dt)
	-- Overrided by subclasses
end

function Sprite:endFrame(dt)
	-- Overrided by subclasses
end

function Sprite:processCollision(other, callback)

	if instanceOf(SpriteGroup, other) then

		for _, member in other:members() do

			self:processCollision(member, callback)

		end

	else
		-- If collision occurs
		if other.active and other.collider and self.collider:collidesWith(other.collider) then
			callback(self, other)
		end
	end

end


function Sprite:draw()

	-- TODO handle images
	love.graphics.setColor(self.fill:unpack())
	self.shape:draw('fill')

	--[[
	if self.img then
		love.graphics.draw(self.img, self.shape.position.x, self.transform.position.y, self.width, self.height)
	else
		love.graphics.setColor(self.fill[1], self.fill[2], self.fill[3])
		love.graphics.rectangle("fill", self.transform.position.x, self.transform.position.y, self.width, self.height)
	end
	-- ]]
end
