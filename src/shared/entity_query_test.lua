require 'core.entity.entityquery'
require 'core.components.emitter'
require 'core.components.behavior'
require 'core.components.collider'
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