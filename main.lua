if arg[#arg] == "-debug" then debug = true else debug = false end
if debug then require("mobdebug").start() end

function love.load()
  currentSeason = 1
  seasons = { "spring", "summer", "autumn", "winter" }
  
  issues = {}
  resources = {
    newResource("wealth"),
    newResource("wealth"),
    newResource("wealth"),
    newResource("might"),
    newResource("might"),
    newResource("might"),    
  }
  score = 0
  mouse = { x = 0, y = 0 }
  selectedResource = {}
  
  factions = {
    newFaction("derpderp"),
    newFaction("narknark"),        
  }
    
end

function newFaction(name)
  return {
      name =  name,
      standing = 5,
      power = 5,      
    }
end

function love.update(dt)  
end

function love.draw(dt)
  love.graphics.setColor(255,255,255,255)
  love.graphics.print(getSeason(), 20, 20 )
  
  love.graphics.print("score: " .. score ,100, 20 )
  
  love.graphics.print("mouse: " .. mouse.x .. "," .. mouse.y,170, 20 )
  
  for k, issue in ipairs(issues) do
    drawIssue(issue, k * 160 - 150, 40)    
  end

  for k, resource in ipairs(resources) do
    drawResource(resource, k * 20, 250 )
  end
  
  for k, faction in ipairs(factions) do
    drawFaction(faction, -150 + 200 * k, 300 )
  end

end

function drawFaction(faction, x, y)
  
  love.graphics.setColor(255,255,255,255)
  love.graphics.print(faction.name, x, y)
  love.graphics.print("standing: " .. faction.standing, x, y + 15)
  love.graphics.print("power: " .. faction.power, x, y + 30)
  
end

function drawIssue(issue, x, y)
    if issue.type == "problem" then
      love.graphics.setColor(150,0,0,255)
    elseif issue.type == "opportunity" then
      love.graphics.setColor(0,150,0,255)
    end
    love.graphics.rectangle("fill", x, y, 150,150)
    
    for k, need in ipairs(issue.needs) do
      drawNeed(need, x - 15 + k * 20, y + 20)
    end
    
    for k, gain in ipairs(issue.gains) do
      drawGain(gain, x - 15 + k * 20, y + 40)
    end
  
    for k, loss in ipairs(issue.losses) do
      drawLoss(loss, x - 15 + k * 20, y + 60)
    end
  
    love.graphics.setColor(255,255,255,255)
    love.graphics.rectangle("fill", x+2,y+2, 7, 7)
    love.graphics.print(issue.type, x + 15, y + 2 )
    
    if issue:metNeeds() then
      love.graphics.setColor(0,255,0,255)
    else
      love.graphics.setColor(255,0,0,255)
    end
    love.graphics.rectangle("fill", x+3,y+3, 5, 5)
    
end

function drawNeed(need, x, y)
  if need.type == "wealth" then
    love.graphics.setColor(0,200,150,255)
  elseif need.type == "might" then
    love.graphics.setColor(100,100,100,255)
  end
  love.graphics.rectangle("fill", x, y, 15,15)
  
  love.graphics.setColor(255,255,255,255)
  love.graphics.rectangle("fill", x, y, 5,5)
  
  if need.met then
    love.graphics.setColor(0,255,0,255)
  else
    love.graphics.setColor(255,0,0,255)
  end
  love.graphics.rectangle("fill", x+1, y+1, 3,3)
  
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

function drawGain(gain, x, y)
  love.graphics.setColor(255,255,255,255)
  gain:draw(x,y)
end

function drawLoss(loss, x, y)
  love.graphics.setColor(255,255,255,255)
  loss:draw(x,y)
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
    if x > k * 20 and x < k * 20 + 15 and y > 250 and y < 270 then
      selectedResource.key = k
      selectedResource.resource = resource
    end    
  end
  
  if selectedResource.key then
    for k, issue in ipairs(issues) do
      if x > k * 160 - 150 and x < k * 160 and y > 40 and y < 190 then
        if issue:give(selectedResource.resource) then          
          table.remove( resources, selectedResource.key )
          selectedResource = {}
        end
      end
    end
  end
end

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
  cleanup()
  
  checkWinLose()
  
  nextSeason()
  revealNewProblems()
  revealNewOpportunities()
  backToAssignPhase()
  
end

function resolveAllIssues()
  for _, issue in ipairs(issues) do
    issue.done = true
    issue:resolve()
  end
  
end

function newIssue(issueType, needs, gains, losses)
  return {
    type = issueType,
    needs = needs,
    gains = gains,
    losses = losses,
    resources = {},
    resolve = function(self)
      if self:metNeeds() then
        for k, gain in ipairs(self.gains) do
          gain:resolve()
        end
      else
        for k, loss in ipairs(self.losses) do
          loss:resolve()
        end
      end
    end,
    metNeeds = function(self)
      return #self.needs == #self.resources 
    end,
    give = function(self, resource)
      for _, want in ipairs(self.needs) do
        if not want.met and want.type == resource.type then
          want.met = true
          table.insert(self.resources, resource)
          return true
        end
      end
      return false
    end
  }
end

function newScoreReward(value)
  return {
    value = value, 
    resolve = function() 
      score = score + value 
    end, 
    draw = function(self, x, y) 
      if self.value > 0 then
        love.graphics.print( "+" .. self.value .. " score", x, y) 
      else
        love.graphics.print( self.value .. " score", x, y) 
      end 
    end
  }
end

function newResourceReward(resource)
  return {
    resource = resource, 
    resolve = function(self) table.insert(resources, self.resource) end, 
    draw = function(self, x, y) drawResource(self.resource, x, y) end 
  }  
end

function newStandingReward(faction, value)
  return {
      faction = faction,
      value = value,
      resolve = function(self) 
        faction.standing = faction.standing + value
      end,
      draw = function(self, x, y)
        love.graphics.print( self.value .. " standing with " .. faction.name, x, y)
      end
  }
end

function newPowerReward(faction, value)
  return {
      faction = faction,
      value = value,
      resolve = function(self) 
        faction.power = faction.power + value
      end,
      draw = function(self, x, y)
        love.graphics.print( self.value .. " power for " .. faction.name, x, y)
      end
  }
end

function revealNewProblems()
  table.insert( issues,
    newIssue("problem", {newResource("might"),newResource("wealth"),newResource("might")}, {}, {
      newStandingReward(factions[1], -1)
    })
  )
  if factions[1].standing < 3 then
    table.insert( issues,
      newIssue("problem", {newResource("might")}, {}, {
        newScoreReward(-3)
      })
    )    
  end
end

function revealNewOpportunities()
  table.insert( issues,
    newIssue("opportunity", {newResource("might")}, {
        newPowerReward(factions[1], 1)
    }, {})
  )  
end

function newResource(type)
  return {
    type = type
  }
end

function returnAllResources()
  for i, issue in ipairs(issues) do
    for r, resource in ipairs(issue.resources) do
      if not resource.consumable then
        table.insert(resources, resource)
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
  cleanDoneIssues()
  cleanFactions()
end

function cleanFactions()
  for k, faction in ipairs(factions) do
    if faction.standing > 10 then
      score = score + faction.standing - 10
      faction.standing = 10
    end
    if faction.standing < 1 then
      score = score - faction.standing - 1
      faction.standing = 1
    end
    if faction.power > 10 then
      score = score + faction.power - 10
      faction.power = 10
    end
    if faction.power < 1 then
      score = score - faction.power - 1
      faction.power = 1
    end    
  end
end

function cleanDoneIssues()
  local i = #issues
  while i > 0 do
    if issues[i].done then
      table.remove(issues, i)
    end
    i = i - 1
  end
end