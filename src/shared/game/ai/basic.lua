
AIBasic = {}

function AIBasic.sleep(time)
  local elapsed = 0

  while elapsed < time do

      -- Yield returns extra arguments passed to resume, which
      -- for our system is always DT in this case "dt"

      elapsed = elapsed + coroutine.yield()

  end

end

return AIBasic

