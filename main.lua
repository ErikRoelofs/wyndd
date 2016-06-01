if arg[#arg] == "-debug" then debug = true else debug = false end
if debug then require("mobdebug").start() end

function love.load()
  currentSeason = 1
  seasons = { "spring", "summer", "autumn", "winter" }
  
  issues = {}
  resources = {
    {
      type = "wealth"
    },
    {
      type = "might"
    }    
  }
  score = 0
  mouse = { x = 0, y = 0 }
  selectedResource = {}
  
  --verify()
end

function love.update(dt)
  --mouse.x, mouse.y = love.mouse:getPosition()
end

function love.draw(dt)
  love.graphics.setColor(255,255,255,255)
  love.graphics.print(getSeason(), 20, 20 )
  
  love.graphics.print("score: " .. score ,100, 20 )
  
  love.graphics.print("mouse: " .. mouse.x .. "," .. mouse.y,170, 20 )
  
  for k, issue in ipairs(issues) do
    drawIssue(issue, k * 60, 40)    
  end

  for k, resource in ipairs(resources) do
    drawResource(resource, k * 20, 100 )
  end

end

function drawIssue(issue, x, y)
    if issue.type == "problem" then
      love.graphics.setColor(255,0,0,255)
    elseif issue.type == "opportunity" then
      love.graphics.setColor(0,255,0,255)
    end
    love.graphics.rectangle("fill", x, y, 50,50)
    
    if issue.resources then
      for k, resource in ipairs(issue.resources) do
        drawResource(resource, x - 15 + k * 20, y + 20)
      end
    end
    
end

function drawResource(resource, x, y)
  if selectedResource.resource == resource then
    love.graphics.setColor(255,255,255,255)
    love.graphics.rectangle("fill", x-1, y-1, 17,17)
  end
  
  
  if resource.type == "wealth" then
    love.graphics.setColor(0,200,150,255)
  elseif resource.type == "might" then
    love.graphics.setColor(100,100,100,255)
  end
  love.graphics.rectangle("fill", x, y, 15,15)
end

function love.keypressed(key, scancode)
  if key == "q" then
    endTheTurn()
  end
end

function love.mousepressed(x, y, button)
  mouse.x = x
  mouse.y = y
      
  for k, resource in ipairs(resources) do
    if x > k * 20 and x < k * 20 + 15 and y > 100 and y < 115 then
      selectedResource.key = k
      selectedResource.resource = resource
    end    
  end
  
  if selectedResource.key then
    for k, issue in ipairs(issues) do
      if x > k * 60 and x < k * 60 + 50 and y > 40 and y < 90 then
        if #issue.resources < #issue.needs then
          table.insert( issue.resources, selectedResource.resource )
          table.remove( resources, selectedResource.key )
          selectedResource = {}
        end
      end
    end
  end
end

--[[
- assign resources
- end turn
- resolve all open issues
 - create new problems
 - take resources
 - update counters
 - change kingdom parts
- return all remaining resources
- check win/lose
V change to new season
- reveal new problems/opportunities, close existing problems/opportunities
- next turn
--]]

function getSeason()
  return seasons[currentSeason]
end

function nextSeason()
  if currentSeason < #seasons then
    currentSeason = currentSeason + 1
  else
    currentSeason = 1
  end
end

function endTheTurn()
  resolveAllIssues()
  returnAllResources()
  checkWinLose()
  nextSeason()
  revealNewProblems()
  revealNewOpporunities()
  backToAssignPhase()
  cleanup()
end

function resolveAllIssues()
  for _, issue in ipairs(issues) do
    issue.done = true
    issue:resolve()
  end
  
end

function newIssue(issueType, needs, gain, lose)
  return {
    type = issueType,
    needs = needs,
    gain = gain,
    lose = lose,
    resources = {},
    resolve = function(self)
      if #self.needs == #self.resources then
        self:gain()
      else
        self:lose()
      end
    end    
  }
end

function revealNewProblems()
  table.insert( issues,
    newIssue("problem", {1}, function() end, function() score = score - 1 end)
  )
end

function revealNewOpporunities()
  table.insert( issues,
    newIssue("opportunity", {}, function() score = score + 1 end, function() end)
  )  
end

function returnAllResources()
  for i, issue in ipairs(issues) do
    if issue.resources then
      for r, resource in ipairs(issue.resources) do
        if not resource.consumable then
          table.insert(resources, resource)
        end
      end
    end
  end
end

function checkWinLose()

end

function backToAssignPhase()
  
end

function assignPhase()  
end

function cleanup()
  local i = #issues
  while i > 0 do
    if issues[i].done then
      table.remove(issues, i)
    end
    i = i - 1
  end
end

function verify()
  verifySeasons()
  verifyEndTheTurn()
end

function verifySeasons() 
  assert(getSeason() == "spring")
  nextSeason()
  assert(getSeason() == "summer")
  nextSeason()
  assert(getSeason() == "autumn")
  nextSeason()
  assert(getSeason() == "winter")
  nextSeason()
  assert(getSeason() == "spring")  
end

function verifyEndTheTurn()
  endTheTurn()
end

function verifyAssignPhase()
  assignPhase()
end