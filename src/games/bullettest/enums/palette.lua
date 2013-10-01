-- Fixed color palettes, so we can refer to colors by name or purpose 
-- rather than by magic numbers

require 'core.color'
Palette = {}

Palette.COLOR_SHIP = Color(147,147,205)
Palette.COLOR_BULLET = Color.fromHex("ffffff")
Palette.COLOR_BACKGROUND = Color(63, 63, 63, 255)

return Palette
