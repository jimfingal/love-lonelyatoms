require 'collections.set'
require 'collections.list'
require 'collections.multimap'
require 'collections.tally'



function tallytest()

	t = Tally()

	print("initializing tally")
	print(t)
	assert(t:getCount("a") == 0, "Uninitialized count should return 0 and not error")
	
	print("incrementing a")
	t:increment("a")
	print(t)
	assert(t:getCount("a") == 1, "Incremented counter should go up 1, instead is " .. tostring(t:getCount("a")))

	print("incrementing a")
	t:increment("a")
	print(t)
	assert(t:getCount("a") == 2, "Incremented counter should go up 1, instead is " .. tostring(t:getCount("a")))

	print("incrementing b")
	t:increment("b")
	print(t)
	assert(t:getCount("b") == 1, "Incremented counter should go up 1, instead is " .. tostring(t:getCount("b")))
	assert(t:getCount("a") == 2, "other counter should stay the same, instead is " .. tostring(t:getCount("a")))

	print("adding 5 to c and a")
	t:add("a", 5)
	t:add("c", 5)
	print(t)
	assert(t:getCount("b") == 1, "other counter should stay the same, instead is " .. tostring(t:getCount("b")))
	assert(t:getCount("a") == 7, "adding 5 should make 'a' 7, instead is " .. tostring(t:getCount("a")))
	assert(t:getCount("c") == 5, "adding 5 should make 'c' 5, instead is " .. tostring(t:getCount("c")))


	print("resetting a")
	t:reset("a")
	print(t)
	assert(t:getCount("a") == 0, "reset should return count back down to 0, instead is " .. tostring(t:getCount("a")))
	assert(t:getCount("b") == 1, "other counter should stay the same, instead is " .. tostring(t:getCount("b")))

	print("clearing tally")
	t:clear()
	print(t)
	assert(t:getCount("a") == 0, "cleared should return count back down to 0, instead is " .. tostring(t:getCount("a")))
	assert(t:getCount("b") == 0, "cleared should return count back down to 0, instead is " .. tostring(t:getCount("a")))


end


tallytest()



