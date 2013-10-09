function load_img(s)
    s = love.image.newImageData(s)
    local w, h = s:getWidth(), s:getHeight()
    local wp = math.pow(2, math.ceil(math.log(w)/math.log(2)))
    local hp = math.pow(2, math.ceil(math.log(h)/math.log(2)))
    if wp ~= w or hp ~= h then
        local padded = love.image.newImageData(wp, hp)
        padded:paste(s, 0, 0)
        s = padded
    end
    local ret = love.graphics.newImage(s)
    ret:setFilter("nearest","nearest")
    return ret
end

function draw(img, x, y)
    gfx_q:push({love.graphics.draw, {img, x, y}})
end

function rectangle(x, y, w, h)
    --love.graphics.rectangle("fill", x, y, w, h)
    gfx_q:push({love.graphics.rectangle, {"fill", x, y, w, h}})
end

function gprint(str, x, y)
    gfx_q:push({love.graphics.print, {str, x, y}})
end

function set_color(r, g, b, a)
    --love.graphics.setColor(r,g,b,a)
    gfx_q:push({love.graphics.setColor, {r, g, b, a}})
end

function graphics_init()
    framebuffer = love.graphics.newFramebuffer(1024, 1024)
    --ASSS = load_img("panel54.png")
end
