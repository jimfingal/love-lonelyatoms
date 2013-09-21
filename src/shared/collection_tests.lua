require 'collections.set'
require 'collections.list'
require 'collections.multimap'


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




settest()
listtest()
multimaptest()



