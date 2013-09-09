require 'external.middleclass'

InputManager = class("InputManager")

function InputManager:initialize()

  self.input_to_action = {} -- Key to action map
  self.held = {} -- Actions that have been held for more than one frame
  self.pressed = {} -- Actions that have been initiated just this frame

end

function InputManager:registerInput(key, action_constant)

  self.input_to_action[key] = action_constant

end


function InputManager:update(dt)

  actions_seen = {}
  pressed = {}

  for key, action_constant in pairs(self.input_to_action) do

    -- Check every key that is registered
    if love.keyboard.isDown(key) then


      actions_seen[action_constant] = true

      previous_dt = self.held[action_constant]

      -- If it was pressed the last time we checked, add on to the time it's been held, and 
      -- remove it from the "just pressed" map
      if previous_dt and not actions_seen[action_constant] then

        self.held[action_constant] = dt + previous_dy

      else

        -- Otherwise, register it in just pressed and that it has been held for dt seconds
        actions_seen[action_constant] = true
        self.pressed[action_constant] = true
        self.held[action_constant] = dt

      end

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
function InputManager:newAction(action_constant)

  return self.pressed[action_constant]

end

-- Return whether the key to trigger a given action has been held - if so return dt
function InputManager:heldAction(action_constant)
  return self.held[action_constant]
end