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

print(Set.union(s2, s3))
print(Set.union(s3, s2))

-- Throw some asserts in here

print('intersection both ways: ')
print(Set.intersection(s2, s3))
print(Set.intersection(s3, s2))

l = List({'a', 'b', 'c', 'a'})

l:prepend('first')

print(l)

l:append('last')

print(l)

print(l:contains('b'))

print(l:memberAt(2))

l:removeFirst('a')

print(l)