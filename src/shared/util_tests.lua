
require 'utils.tally'
require 'utils.pool'



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


function pooltest()

	pool1 = Pool()
	print("Initializing empty pool")
	print(pool1)

	local newTally = function()
		return Tally:new()
	end

	pool2 = Pool(newTally, 2)

	print(pool2)

	print("Getting a tally object from the pool")
	tally1 = pool2:getObject()
	print(pool2)
	print(tally1)
	assert(instanceOf(Tally, tally1), "Tally 1 should exist and be a Tally")
	assert(pool2.used_objects:contains(tally1), "Used objects should contain tally1")
	assert(pool2.used_count == 1, "Used count should be 1")

	print("Getting a tally object from the pool")
	tally2 = pool2:getObject()
	print(pool2)
	print(tally2)
	assert(pool2.used_objects:contains(tally2), "Used objects should contain tally2")
	assert(instanceOf(Tally, tally2), "Tally 2 should exist and be a Tally")
	assert(pool2.used_count == 2, "Used count should be 2")

	print("Getting a tally object from the pool")
	tally3 = pool2:getObject()
	print(pool2)
	print(tally3)
	assert(not tally3, "Tally 3 should be nil")
	assert(pool2.used_count == 2, "Used count should be 2")

	print("Recycling Tally 2")
	pool2:recycle(tally2)
	print(pool2)
	assert(pool2.recycled_objects:contains(tally2), "Recycled objects should contain tally2")
	assert(pool2.used_count == 1, "Used count should be 1")
	assert(pool2.recycled_count == 1, "Recycled count should be 1")

	pool2:setObjectResetFunction(function(object) object:increment("a") end)


	tally4 = pool2:getObject()
	print(pool2)
	assert(tally4 == tally2, "We should have retrieved the recycled object")
	assert(not pool2.recycled_objects:contains(tally4), "Recycled objects should not contain tally4")
	assert(pool2.used_objects:contains(tally4), "Used objects should contain tally4")
	assert(pool2.used_count == 2, "Used count should be 2")
	assert(pool2.recycled_count == 0, "Recycled count should be 0")

	pool3 = Pool(newTally, 10)
	print("Initializing Pool of pools with 10 max items")
	print(pool3)

	print("Initializing all objects")
	pool3:initializeRemainingObjects()
	print(pool3)
	assert(pool3.used_count == 0, "Used count should be 0")
	assert(pool3.recycled_count == 10, "Recycled count should be 10")
	assert(pool3.recycled_objects:size() == 10, "Recycled objects should be 10 items long")

end



-- tallytest()

pooltest()


