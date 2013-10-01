-- Fixed color palettes, so we can refer to colors by name or purpose 
-- rather than by magic numbers

require 'core.color'
Palette = {}

Palette.COLOR_SHIP = Color.fromHex("490a3d")
Palette.COLOR_BULLET = Color.fromHex("ffffff")

return Palette
