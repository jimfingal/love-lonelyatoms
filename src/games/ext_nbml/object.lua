Object = class(function(o, x, y, direction, speed, sprite, kind, ...)
        o.x             = x         or 400
        o.y             = y         or 300
        o.direction     = direction or facing_down
        o.speed         = speed     or 0
        o.img           = img       or nil
        o.kind          = kind      or "enemy_bullet"
        o.age           = 0
        o.dead          = false
        o.health        = 1
        o.x_accel       = 0
        o.x_accel_turns = 0
        o.y_accel       = 0
        o.y_accel_turns = 0
        o.accel         = 0
        o.accel_turns   = 0
        o.rot           = 0
        o.rot_turns     = 0
        o.child_img     = o.img
        o.child_kind    = o.kind
        if obj_man then
            obj_man:add(o)
            for junk, args in pairs({...}) do
                obj_man:register(o, args)
            end
        end
    end)

function Object.run(self)
    if self.accel_turns > 0 then
        self.speed = self.speed + self.accel
        self.accel_turns = self.accel_turns - 1
    end
    if self.rot_turns > 0 then
        self.direction = self.direction + self.rot
        self.rot_turns = self.rot_turns - 1
    end
    local dx,dy = get_cartesian(self.speed, self.direction)
    local redo_speed_dir = false
    if self.x_accel_turns > 0 then
        redo_speed_dir = true
        dx = dx + self.x_accel
    end
    if self.y_accel_turns > 0 then
        redo_speed_dir = true
        dy = dy + self.y_accel
    end
    if redo_speed_dir then
        self.speed, self.direction = get_polar(dx, dy)
    end
    self.x = self.x + dx
    self.y = self.y + dy
    -- TODO: don't hard code dimensions of space.
    self.dead = self.dead or self.x < -100 or self.y < -100 or
        self.x > 900 or self.y > 700-- or self.health <= 0
    self.age = self.age + 1
end

function Object.draw(self)
    rectangle(self.x - 5, self.y - 5, 10, 10)
end

function Object.get_x(self)
    return self.x
end

function Object.get_y(self)
    return self.y
end

function Object.get_age(self)
    return self.age
end
Object.get_turn = Object.get_age

--function Object.getRank(self){return rank; end

function Object.get_speed_x(self)
    return get_x_from_polar(self.speed,self.direction)
end

function Object.get_speed_y(self)
    return get_y_from_polar(self.speed,self.direction)
end

function Object.get_direction(self)
    return self.direction
end

function Object.get_speed(self)
    return self.speed
end

--function getID(){return (function)activeObject; end
--function getNewest(){return (function)newestObject; end
function Object.set_speed_polar(self, r, theta)
    self.speed      = r
    self.direction  = theta
end
Object.set_speed = Object.set_speed_polar

function Object.set_speed_cartesian(self, x, y)
    self.speed, self.direction = get_polar(x, y)
end

function Object.change_speed(self, speed, turns)
    self.accel          = (speed-self.speed)/turns;
    self.accel_turns    = turns;
end

function Object.change_direction(self, direction, turns)
    direction      = direction % tau;
    self.direction = self.direction % tau
    self.rot       = (direction - self.direction)
    self.rot_turns = turns
    if direction - self.direction > pi then
        self.rot = self.rot - tau
    elseif direction - self.direction < -pi then
        self.rot = self.rot + tau
    end
    self.rot = self.rot / turns
end

function Object.aim(self)
    if (not obj_man) or #obj_man.objects["player"] == 0 then
        print("oh shit")
        return facing_down
    end
    local player = obj_man.objects["player"][1]
    return get_theta(player.x-self.x, player.y-self.y)
end

function Object.vanish(self)
    self.dead = true
    coroutine.yield(0)
end

function Object.set_child_img(self, img)
    self.child_img = img
end

function Object.set_child_kind(self, kind)
    self.child_kind = kind
end

-- each member of ... should be of form {func, ...}
-- a new routine will be created that runs func(child, ...)
-- they can also just be functions mmkay
function Object.fire(self, r, theta, ...)
    if self.dead then
        return
    end
    local child = Object(self.x, self.y, theta, r,
        self.child_img, self.child_kind)
    for idx, args in pairs({...}) do
        obj_man:register(child, args)
    end
end

function wait(how_long)
    if how_long then
        how_long = floor(how_long)
        if how_long < 1 then
            return
        end
    else
        how_long = 1
    end
    coroutine.yield(how_long)
end
