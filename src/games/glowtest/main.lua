

function glowShape(r, g, b, type, ...)
  love.graphics.setColor(r, g, b, 15)
  
  for i = 100, 2, -1 do
    if i == 2 then
      i = 1
      love.graphics.setColor(r, g, b, 255)    
    end
    
    love.graphics.setLineWidth(i)
    
    if type == "line" then
      love.graphics[type](...)
    else
      love.graphics[type]("line", ...)
    end
  end
end

function love.draw()
  glowShape(255, 0, 0, "rectangle", 200, 100, 100, 100)
  glowShape(0, 255, 0, "polygon", 300, 300, 310, 330, 350, 290, 360, 310, 290, 350)
end