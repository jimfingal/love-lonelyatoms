-- Fixed color palettes, so we can refer to colors by name or purpose 
-- rather than by magic numbers

require 'game.color'
Palette = {}

Palette.COLOR_BACKGROUND = Color.fromHex("490a3d")
Palette.COLOR_BRICK = Color.fromHex("bd1550")
Palette.COLOR_BALL = Color.fromHex("f8ca00")
Palette.COLOR_PADDLE = Color.fromHex("e97f02")
Palette.COLOR_TRAIL = Color.fromHex("8a9b0f")
Palette.COLOR_SPARK = Color.fromHex("ffffff")
Palette.COLOR_BOUNCY_LINES = Color.fromHex("bd1550")

return Palette
