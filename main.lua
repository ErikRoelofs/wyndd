--[[
  V chained issues
  V multi-turn issues
  V persistent issues
  V faction creating issues
  faction-based issues
  win/lose condition
  hungry needs
  multi-resources
]]
if arg[#arg] == "-debug" then debug = true else debug = false end
if debug then require("mobdebug").start() end

require "draw"
require "resource"
require "reward"
require "issue"
require "faction"

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
  
  factions = {}
  
  factions = {
    newFaction("derpderp", {}),
    newFaction("narknark", {}),        
  }
  
  function standingBasedPotential(faction, standing, rewards)
    return newPotential(
      newIssue("problem", {newResource("wealth")}, {}, rewards, 1, false), function() return faction.standing > standing end)
  end
  local potential = standingBasedPotential(factions[1], 2, {newStandingReward(factions[1], -1)})
    
  factions[1]:addPotential(potential)
  
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
  revealNewIssues()
  backToAssignPhase()
  
end

function resolveAllIssues()
  for _, issue in ipairs(issues) do
    issue.done = true    
  end
  for _, issue in ipairs(issues) do
    if issue.done == true then
      issue:resolve()
    end
  end
  
end

function revealNewIssues()
  revealNewProblems()
  revealNewOpportunities()
  
  for k, faction in ipairs(factions) do
    faction:revealNewIssues()
  end
  
end

function revealNewProblems()
  --[[
  table.insert( issues,
    newIssue("problem", {newResource("wealth")}, {}, {
      newStandingReward(factions[1], -1)
    }, 1, true)
  )
  ]]--
  table.insert( issues,
    newIssue("opportunity", {newResource("wealth")}, {}, {
      newFactionReward(newFaction("bargl", {}))
    }, 1, true)
  )  
end

function revealNewOpportunities()
  table.insert( issues,
    newIssue("opportunity", {newResource("might")}, {
        newScoreReward(1000)
    },
    {
        newScoreReward(-5)
    }, 3)
  )  
end

function returnAllResources()
  for i, issue in ipairs(issues) do
    local r = #issue.resources
    while r > 0 do
      local resource = issue.resources[r]
      if not resource.consumable then
        table.insert(resources, resource)
      end
      table.remove(issue.resources, r)
      r = r -1
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
      score = score + faction.standing - 1
      faction.standing = 1
    end
    if faction.power > 10 then
      score = score + faction.power - 10
      faction.power = 10
    end
    if faction.power < 1 then
      score = score + faction.power - 1
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