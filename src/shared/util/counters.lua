require 'external.middleclass'

Counter = class('Counter')

function Counter:initialize()
	self.counter = 0
end

function Counter:value()
	return self.counter
end

function Counter:decrement()
	self.counter = self.counter - 1
	return self.counter
end

function Counter:increment()
	self.counter = self.counter + 1
	return self.counter
end

CircularCounter = class('CircularCounter')

function CircularCounter:initialize(max, min)
	self.min = min or 0
	self.max = max

	self.counter = self.min

end

function CircularCounter:value()
	return self.counter
end

function CircularCounter:decrement()
	self.counter = self.counter - 1
	
	if self.counter < self.min then
		self.counter = self.max
	end
	
	return self.counter
end

function CircularCounter:increment()
	self.counter = self.counter + 1
	
	if self.counter > self.max then
		self.counter = self.min
	end
	
	return self.counter
end
