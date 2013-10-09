local tasks={}
local objects={}

local function run(fn)
  local co=coroutine.create(fn)
  table.insert(tasks, co)
  return co
end

local MT={}
MT.__index=MT

function MT:draw()
  love.graphics.setColor(self.color)
  love.graphics.rectangle('fill', self.x-5, self.y-5, 10, 10)
  love.graphics.line(self.trace)
end

function MT:forward(n, TIME)
  TIME=TIME or 1 -- keep drawing for 1 second by default
  local elapsed=0
  local sx, sy=self.x, self.y
  local DX=n*math.cos(math.rad(self.angle))
  local DY=n*math.sin(math.rad(self.angle))
  local dx, dy=0,0
  while elapsed<TIME do
    elapsed=elapsed+coroutine.yield()
    dx=elapsed/TIME*DX
    dy=elapsed/TIME*DY
    self.x=sx+dx
    self.y=sy+dy
    self.trace[#self.trace-1]=self.x
    self.trace[#self.trace]=self.y
  end
  self.x=sx+DX
  self.y=sy+DY
  self.trace[#self.trace-1]=self.x
  self.trace[#self.trace]=self.y
  self.moved=true
end

function MT:rotate(r)
  self.angle=self.angle+r
  if self.moved then
    self.trace[#self.trace+1]=self.x
    self.trace[#self.trace+1]=self.y
  end
  self.moved=false
end

function MT:sleep(t)
  local elapsed=0
  print('Sleeping for '..t)
  while elapsed<t do
    elapsed=elapsed+coroutine.yield()
  end
  print('Done sleeping')
end

local function newObject(x, y, color)
  local o=setmetatable({x=x, y=y, angle=0, color=color or {255, 0, 0}}, MT)
  o.trace={o.x, o.y, o.x, o.y}
  table.insert(objects, o)
  return o
end

function love.load()
  local red=newObject(100, 100, {255,0,0})
  local green=newObject(200, 150, {0, 255,0})


-- AI logic
  run(function()
    red:forward(100)
    red:rotate(90)
    red:forward(100, 2)
    red:rotate(90)
    red:forward(100, 0.5)
    red:rotate(90)
    red:forward(100)
  end)
  run(function()
    green:rotate(45)
    green:forward(200, 0.1)
  end)
  run(function()
    green:sleep(1.5)
    green:rotate(120)
    green:forward(200)
    green:rotate(120)
    green:forward(200)
    green:rotate(120)
    green:forward(200)
    green:sleep(2)
    love.event.push('quit')
  end)
end

function love.draw()
  for k,v in ipairs(objects) do
    v:draw()
  end
end

function love.update(dt)
  local n={}
  for k, v in ipairs(tasks) do
    table.insert(n, table.remove(tasks, 1))
  end
  for k,v in ipairs(n) do
    st, err=coroutine.resume(v, dt)
    if not st then
      print('Coro exited:', err)
    else
      table.insert(tasks, v)
    end
  end
end

