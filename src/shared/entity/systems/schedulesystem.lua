require 'external.middleclass'

ScheduleSystem = class("ScheduleSystem", System)

function ScheduleSystem:initialize()

	System.initialize(self, 'Schedule System')

	-- Key is {func, func_after}, value is duration to keep calling
	self.running = {}

	-- Key is {function to call, duration}, value is time left
	self.delayed = {}

	self.periodic = {}

	self.expired = {}

	-- self.time = 0
end

function ScheduleSystem:update(dt)

	-- self.time = self.time + dt

	-- Ongoing
	for re, remaining in pairs(self.running) do
		
		local remaining = remaining - dt

		if remaining < 0 then

			self.expired[re] = true

			if re.func_after then
				re.func_after()
			end

		else

			re.func(dt)
			self.running[re] = remaining

		end

	end

	-- Scheduled to run once
	for entry, remaining_until in pairs(self.delayed) do
		
		remaining_until = remaining_until - dt

		if remaining_until < 0 then
			entry.func()
			self.expired[entry] = true

		else
			self.delayed[entry] = remaining_until
		end
			
	end

	-- Periodic

	for entry, remaining_until in pairs(self.periodic) do
		
		local remaining_until = remaining_until - dt

		if remaining_until < 0 then

			entry.func(dt)
			
			-- If we go slightly over account for that next time
			self.periodic[entry] = entry.duration + remaining_until

		else
			self.periodic[entry] = remaining_until

		end
			
	end

	self:processExpiredEntries()

end

function ScheduleSystem:processExpiredEntries()

	for entry, _ in pairs(self.expired) do 
		self.delayed[entry] = nil
		self.running[entry] = nil
	end
end


function ScheduleSystem:doFor(duration, func, func_after)

	local entry = {func = func, func_after = func_after, duration = duration}
	self.running[entry] = duration

end

function ScheduleSystem:doAfter(duration, func)

	local entry = {func = func, duration = duration}
	self.delayed[entry] = duration

end

function ScheduleSystem:doEvery(duration, func)

	local entry = {func = func, duration = duration}
	self.periodic[entry] = duration

end


-- do_after

-- do_for

-- do_every

-- update