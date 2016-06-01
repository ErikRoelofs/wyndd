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
  
  --verify()
end

function love.update(dt)
  
end

function love.draw(dt)
  love.graphics.setColor(255,255,255,255)
  love.graphics.print(getSeason(), 20, 20 )
  
  love.graphics.print("score: " .. score ,100, 20 )
  
  for k, issue in ipairs(issues) do
    if issue.type == "problem" then
      love.graphics.setColor(255,0,0,255)
    elseif issue.type == "opportunity" then
      love.graphics.setColor(0,255,0,255)
    end
    love.graphics.rectangle("fill", k * 20, 40, 15,15)
  end

  for k, resource in ipairs(resources) do
    if resource.type == "wealth" then
      love.graphics.setColor(0,200,150,255)
    elseif resource.type == "might" then
      love.graphics.setColor(100,100,100,255)
    end
    love.graphics.rectangle("fill", k * 20, 60, 15,15)
  end


end

function love.keypressed(key, scancode)
  if key == "q" then
    endTheTurn()
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
end

function resolveAllIssues()
  for _, issue in ipairs(issues) do
    if math.random() > 0.5 then
      issue.done = true
      score = score + 1      
    end
    local i = #issues
    while i > 0 do
      if issues[i].done then
        table.remove(issues, i)
      end
      i = i - 1
    end
  end
  
end

function revealNewProblems()
  table.insert( issues, {
    type = "problem"
  } )
end

function revealNewOpporunities()
  table.insert( issues, {
    type = "opportunity"
  } )  
end

function returnAllResources()

end

function checkWinLose()

end

function backToAssignPhase()
  
end

function assignPhase()
  
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