require 'collections.set'
require 'collections.list'

s = Set({'a', 'b', 'c', 'a'})
print(s)

s:add('q')
print(s)

s:remove('a')
print(s)


l = List({'a', 'b', 'c', 'a'})

l:prepend('first')

print(l)

l:append('last')

print(l)

print(l:contains('b'))

print(l:memberAt(2))

l:removeFirst('a')

print(l)