require 'external.middleclass'

PoolSource = class('PoolSource')

-- Stub class
function PoolSource:initialize()

end

-- A function which returns us an object to the pool.
function PoolSource:create()

end

-- A function called on the object when we send it to the recycler. Should do things like
-- disable any updating components.
function PoolSource:recycle(recycled_item)

end

-- A function called on the object when we get it back from the recycler. Could re-initialize
-- components, zero out values we want to reset, etc.
function PoolSource:reset(reset_item)

end