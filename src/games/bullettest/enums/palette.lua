-- Fixed color palettes, so we can refer to colors by name or purpose 
-- rather than by magic numbers

require 'core.color'
Palette = {}

Palette.COLOR_SHIP = Color(100, 100, 100, 255)
Palette.COLOR_BULLET = Color.fromHex("ffffff")
Palette.COLOR_BACKGROUND = Color(15, 15, 15, 255)
Palette.COLOR_OPPONENT = Color.fromHex("f8ca00")

return Palette
