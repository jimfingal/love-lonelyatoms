require 'entity.entityquery'
require 'entity.components.emitter'
require 'entity.components.behavior'
require 'entity.components.collider'
require 'external.middleclass'


eq = EntityQuery()

print(eq)
eq:addOrSet(Emitter, Behavior)
print(eq)
eq:addOrSet(Collider)
print(eq)

q = eq:getQuery()

print(q)

eq:clear()

print(eq)