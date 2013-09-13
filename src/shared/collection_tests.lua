require 'collections.set'
require 'collections.list'

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

print(s2:union(s3))
print(s3:union(s2))

-- Throw some asserts in here

print('intersection both ways: ')
print(s2:intersection(s3))
print(s3:intersection(s2))

l = List({'a', 'b', 'c', 'a'})

l:prepend('first')

print(l)

l:append('last')

print(l)

print(l:contains('b'))

print(l:memberAt(2))

l:removeFirst('a')

print(l)