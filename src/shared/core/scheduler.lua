require 'external.middleclass'

Scheduler = class("Scheduler")

function Scheduler:initialize()

	-- Key is {func, func_after}, value is duration to keep calling
	self.running = {}

	-- Key is {function to call, duration}, value is time left
	self.delayed = {}

	self.periodic = {}

	self.expired = {}

	-- self.time = 0
end

function Scheduler:update(dt)

	-- self.time = self.time + dt

	-- Ongoing
	for entry, remaining in pairs(self.running) do
		
		remaining = remaining - dt

		if remaining < 0 then

			self.expired[entry] = true
			entry.func_after()

		else

			entry.func(dt)
			self.running[entry] = remaining

		end

	end

	-- Scheduled to run once
	for entry, remaining_until in pairs(self.delayed) do
		
		remaining = remaining - dt

		if remaining_until < 0 then

			entry.func(dt)
			self.expired[entry] = true

		end
			
	end

	-- Periodic
	for entry, remaining_until in pairs(self.periodic) do
		
		remaining = remaining - dt

		if remaining_until < 0 then

			entry.func(dt)
			
			-- If we go slightly over account for that next time
			self.periodic[entry] = entry.duration + remaining_until

		end
			
	end

	self:processExpiredEntries()

end

function Scheduler:processExpiredEntries()

	for entry, _ in pairs(self.expired) do 
		self.delayed[entry] = nil
		self.running[entry] = nil
	end
end


function Scheduler:do_for(duration, func, func_after)

	local entry = {func = func, func_after = func_after, duration = duration}
	self.running[entry] = duration

end

function Scheduler:do_after(duration, func)

	local entry = {func = func, duration = duration}
	self.delayed[entry] = duration

end

function Scheduler:do_every(duration, func)

	local entry = {func = func, duration = duration}
	self.periodic[entry] = duration

end


-- do_after

-- do_for

-- do_every

-- update