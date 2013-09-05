require 'collections.set'

s = Set({'a', 'b', 'c', 'a'})
print(s)

s:add('q')
print(s)

s:remove('a')
print(s)
