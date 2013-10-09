

bloom = love.graphics.newPixelEffect [[
vec2 image_size;

vec4 effect(vec4 color, Image tex, vec2 tc, vec2 pc)
{
    vec2 offset = vec2(1.0)/image_size;
    color = Texel(tex, tc); // maybe add a weight here?

    color += Texel(tex, tc + vec2(-offset.x, offset.y));
    color += Texel(tex, tc + vec2(0, offset.y));
    color += Texel(tex, tc + vec2(offset.x, offset.y));

    color += Texel(tex, tc + vec2(-offset.x, 0));
    color += Texel(tex, tc + vec2(0, 0));
    color += Texel(tex, tc + vec2(offset.x, 0));

    color += Texel(tex, tc + vec2(-offset.x, -offset.y));
    color += Texel(tex, tc + vec2(0, -offset.y));
    color += Texel(tex, tc + vec2(offset.x, -offset.y));

    return color / 9.0; // use 10.0 for regular blurring.
}
]]


return bloom