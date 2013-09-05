require 'class.middleclass'
require 'engine.gamestate'
require 'sprites.player'
require 'collections.set'

PlayState = class('Play', GameState)

function PlayState:initialize(name, state_manager, asset_manager)

    GameState.initialize(self, name, state_manager, asset_manager)

    self.player = Player('player', 50, 500, 100, 20)

    self.world = {}

    self.world[1] = self.player


    self.debug = true

end


function PlayState:update(dt)

	for _, sprite in ipairs(self.world) do
    	if sprite.active then
	    	sprite:update(dt)
	    end
    end

end


function PlayState:draw()

    love.graphics.setBackgroundColor(63, 63, 63, 255)

    love.graphics.setColor(204,147,147)
    love.graphics.setFont(self:assetManager():getFont(Assets.FONT_LARGE))
    
    menu_str = "PLAY AROUND!"

    love.graphics.print(menu_str, 200, 25)

    local debugstart = 250

    love.graphics.setFont(self:assetManager():getFont(Assets.FONT_SMALL))

    for _, sprite in ipairs(self.world) do

    	love.graphics.print(tostring(sprite.name), 10, debugstart)
    	debugstart = debugstart + 25

    	if sprite.visible then
	    	sprite:draw()
	    end
    end

    
	if self.debug then
	    

		--[[
	    love.graphics.print("vX:" .. self.ball.x_vel, 10, 250)
	    love.graphics.print("vY:" .. self.ball.y_vel, 10, 275)
	    love.graphics.print("bgdSecs:" .. background_snd:tell("seconds"), 10, 300)
	    love.graphics.print("srcs:" .. love.audio.getNumSources(), 10, 325)
	    love.graphics.print("pS:" .. self.paddle.speed, 10, 350)
	    love.graphics.print("pD:" ..self.paddle.direction, 10, 375)
	    love.graphics.print("pX:" ..self.paddle.x, 10, 400)
	    love.graphics.print("bL:" .. background_length, 10, 425)
	    love.graphics.print("sL:" .. song_length, 10, 450)
        love.graphics.print("fps:" .. self.fps, 10, 475) ]]
	    
    end



end