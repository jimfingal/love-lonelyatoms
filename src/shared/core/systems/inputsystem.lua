require 'external.middleclass'
require 'core.entity.system'
require 'core.components.behavior'


InputSystem = class('InputSystem', System)

function InputSystem:initialize(world)

	System.initialize(self, 'Input Response  System')
	self.world = world

	self.input_to_action = {} -- Key to action map
  	self.held = {} -- Actions that have been held for more than one frame
  	self.pressed = {} -- Actions that have been initiated just this frame

end


function InputSystem:registerInput(key, action_constant)

  self.input_to_action[key] = action_constant

end

function InputSystem:clear()
  self.held = {}
  self.pressed = {}
end


function InputSystem:processInputResponses(entities, dt)
  
	self:update(dt)

	for entity in entities:members() do
	
		local entity_responses = entity:getComponent(InputResponse)

		for _, func in entity_responses:responseFunctions():members() do

			func(entity, self.held, self.pressed, dt)

		end

	end

end


function InputSystem:update(dt)

  local actions_seen = {}
  self.pressed = {}

  for key, action_constant in pairs(self.input_to_action) do

    -- Check every key that is registered
    if love.keyboard.isDown(key) then

      previous_dt = self.held[action_constant]

      -- If it was pressed the last time we checked, add on to the time it's been held, and 
      -- remove it from the "just pressed" map
      if previous_dt and not actions_seen[action_constant] then

        self.held[action_constant] = dt + previous_dt

      else

        -- Otherwise, register it in just pressed and that it has been held for dt seconds
        actions_seen[action_constant] = true
        self.pressed[action_constant] = true
        self.held[action_constant] = dt

      end

      actions_seen[action_constant] = true


    end

  end

  -- At the end of it, loop through again; If haven't seen action, nil out "held"
  for key, action_constant in pairs(self.input_to_action) do

      if not actions_seen[action_constant] then
        self.held[action_constant] = nil
      end

  end

end


-- Return whether the key to trigger a given action has just been initiated
function InputSystem:newAction(action_constant)

  return self.pressed[action_constant]

end

-- Return whether the key to trigger a given action has been held - if so return dt
function InputSystem:heldAction(action_constant)
  return self.held[action_constant]
end


function InputSystem:newActions()
  return self.pressed
end

function InputSystem:heldActions()
  return self.held
end