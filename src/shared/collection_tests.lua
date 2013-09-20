require 'collections.set'
require 'collections.list'
require 'collections.multimap'
require 'collections.tally'


function settest() 
	s = Set({'a', 'b', 'c', 'a'})
	print(s)

	s:add('q')
	print(s)

	s:remove('a')
	print(s)


	s2 = Set({'a', 'b', 'c', 'a'})

	s3 = Set({'b', 'c', 'd'})

	-- Throw some asserts in here
	print('set 2: ' .. tostring(s2))
	print('set 3: ' .. tostring(s3))

	print('union both ways: ')

	print(Set.union(s2, s3))
	print(Set.union(s3, s2))

	-- Throw some asserts in here

	print('intersection both ways: ')
	print(Set.intersection(s2, s3))
	print(Set.intersection(s3, s2))
end

function listtest()
	l = List({'a', 'b', 'c', 'a'})

	l:prepend('first')

	print(l)

	l:append('last')

	print(l)

	print(l:contains('b'))

	print(l:memberAt(2))

	l:removeFirst('a')

	print(l)
end


function multimaptest()
	-- Multimap

	mm = MultiMap()


	s4 = Set({'a', 'b', 'c', 'a'})
	s5 = Set({'b', 'c', 'd'})

	print("put - a, a")
	mm:put('a', 'a')
	print(mm)

	print("remove - a, b")
	mm:remove('a', 'b')
	print(mm)

	print("remove - a, a")
	mm:remove('a', 'a')
	print(mm)

	print("put - a, b+c")
	print("put - b, a")
	mm:put('a', 'b')
	mm:put('a', 'c')
	mm:put('b', 'a')

	print(mm)

	print("putAll - c, a + b + c + a")

	mm:putAll('c', s4)

	print(mm)

	assert(mm:containsKey('a'), "Should contain key")
	assert(mm:containsKey('b'), "Should contain key")
	assert(mm:containsKey('c'), "Should contain key")

	print("printing keys")

	print(mm:keys())

	print("printing values")

	print(mm:values())

	print("clearing")

	mm:clear()

	print(mm)
end


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



settest()
listtest()
multimaptest()
tallytest()



