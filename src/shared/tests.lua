require 'core.animation'

foo = Animation({1, 2, 1}, false)

print(foo.status)

-- Shouldn't update since not playing
foo:update(0.5)

assert(foo.timer == 0, 'Timer should not move forward when not playing, instead was ' .. foo.timer)

foo:play()

foo:update(0.5)
print("Updated 0.5 seconds, timer is now " .. foo.timer .. ' and position is ' .. foo.position .. '; total runtime: ' .. foo.total_runtime)
assert(foo.timer == 0.5, 'Timer should move forward the amount we updated, instead was ' .. foo.timer)
assert(foo.position == 1, "We should be in the first frame, instead are in " .. foo.position)


foo:update(0.5)
print("Updated 0.5 seconds, timer is now " .. foo.timer .. ' and position is ' .. foo.position .. '; total runtime: ' .. foo.total_runtime)
print("Status is " .. foo.status)

foo:update(0.5)
print("Updated 0.5 seconds, timer is now " .. foo.timer .. ' and position is ' .. foo.position .. '; total runtime: ' .. foo.total_runtime)
print("Status is " .. foo.status)
foo:update(0.5)
print("Updated 0.5 seconds, timer is now " .. foo.timer .. ' and position is ' .. foo.position .. '; total runtime: ' .. foo.total_runtime)
print("Status is " .. foo.status)
foo:update(0.5)
print("Updated 0.5 seconds, timer is now " .. foo.timer .. ' and position is ' .. foo.position .. '; total runtime: ' .. foo.total_runtime)
print("Status is " .. foo.status)
foo:update(0.5)
print("Updated 0.5 seconds, timer is now " .. foo.timer .. ' and position is ' .. foo.position .. '; total runtime: ' .. foo.total_runtime)
print("Status is " .. foo.status)
foo:update(0.5)
print("Updated 0.5 seconds, timer is now " .. foo.timer .. ' and position is ' .. foo.position .. '; total runtime: ' .. foo.total_runtime)
print("Status is " .. foo.status)
foo:update(0.5)
print("Updated 0.5 seconds, timer is now " .. foo.timer .. ' and position is ' .. foo.position .. '; total runtime: ' .. foo.total_runtime)
print("Status is " .. foo.status)
foo:update(0.5)
print("Updated 0.5 seconds, timer is now " .. foo.timer .. ' and position is ' .. foo.position .. '; total runtime: ' .. foo.total_runtime)
print("Status is " .. foo.status)
foo:update(0.5)
print("Updated 0.5 seconds, timer is now " .. foo.timer .. ' and position is ' .. foo.position .. '; total runtime: ' .. foo.total_runtime)
print("Status is " .. foo.status)




foo = Animation({1, 2, 1}, true)

print(foo.status)

-- Shouldn't update since not playing
foo:update(0.5)

assert(foo.timer == 0, 'Timer should not move forward when not playing, instead was ' .. foo.timer)

foo:play()

foo:update(0.5)
print("Updated 0.5 seconds, timer is now " .. foo.timer .. ' and position is ' .. foo.position)
assert(foo.timer == 0.5, 'Timer should move forward the amount we updated, instead was ' .. foo.timer)
assert(foo.position == 1, "We should be in the first frame, instead are in " .. foo.position)


foo:update(0.5)
print("Updated 0.5 seconds, timer is now " .. foo.timer .. ' and position is ' .. foo.position .. '; total runtime: ' .. foo.total_runtime)
print("Status is " .. foo.status)
foo:update(0.5)
print("Updated 0.5 seconds, timer is now " .. foo.timer .. ' and position is ' .. foo.position .. '; total runtime: ' .. foo.total_runtime)
print("Status is " .. foo.status)
foo:update(0.5)
print("Updated 0.5 seconds, timer is now " .. foo.timer .. ' and position is ' .. foo.position .. '; total runtime: ' .. foo.total_runtime)
print("Status is " .. foo.status)
foo:update(0.5)
print("Updated 0.5 seconds, timer is now " .. foo.timer .. ' and position is ' .. foo.position .. '; total runtime: ' .. foo.total_runtime)
print("Status is " .. foo.status)
foo:update(0.5)
print("Updated 0.5 seconds, timer is now " .. foo.timer .. ' and position is ' .. foo.position .. '; total runtime: ' .. foo.total_runtime)
print("Status is " .. foo.status)
foo:update(0.5)
print("Updated 0.5 seconds, timer is now " .. foo.timer .. ' and position is ' .. foo.position .. '; total runtime: ' .. foo.total_runtime)
print("Status is " .. foo.status)
foo:update(0.5)
print("Updated 0.5 seconds, timer is now " .. foo.timer .. ' and position is ' .. foo.position .. '; total runtime: ' .. foo.total_runtime)
print("Status is " .. foo.status)
foo:update(0.5)
print("Updated 0.5 seconds, timer is now " .. foo.timer .. ' and position is ' .. foo.position .. '; total runtime: ' .. foo.total_runtime)
print("Status is " .. foo.status)
foo:update(0.5)
print("Updated 0.5 seconds, timer is now " .. foo.timer .. ' and position is ' .. foo.position .. '; total runtime: ' .. foo.total_runtime)
print("Status is " .. foo.status)
foo:update(0.5)
print("Updated 0.5 seconds, timer is now " .. foo.timer .. ' and position is ' .. foo.position .. '; total runtime: ' .. foo.total_runtime)
print("Status is " .. foo.status)
foo:update(0.5)
print("Updated 0.5 seconds, timer is now " .. foo.timer .. ' and position is ' .. foo.position .. '; total runtime: ' .. foo.total_runtime)
print("Status is " .. foo.status)
foo:update(0.5)
print("Updated 0.5 seconds, timer is now " .. foo.timer .. ' and position is ' .. foo.position .. '; total runtime: ' .. foo.total_runtime)
print("Status is " .. foo.status)
foo:update(0.5)
print("Updated 0.5 seconds, timer is now " .. foo.timer .. ' and position is ' .. foo.position .. '; total runtime: ' .. foo.total_runtime)
print("Status is " .. foo.status)
foo:update(0.5)
print("Updated 0.5 seconds, timer is now " .. foo.timer .. ' and position is ' .. foo.position .. '; total runtime: ' .. foo.total_runtime)
print("Status is " .. foo.status)
foo:update(0.5)
print("Updated 0.5 seconds, timer is now " .. foo.timer .. ' and position is ' .. foo.position .. '; total runtime: ' .. foo.total_runtime)
print("Status is " .. foo.status)
foo:update(0.5)
print("Updated 0.5 seconds, timer is now " .. foo.timer .. ' and position is ' .. foo.position .. '; total runtime: ' .. foo.total_runtime)
print("Status is " .. foo.status)
