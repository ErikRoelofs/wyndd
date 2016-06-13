--[[
  V chained issues
  V multi-turn issues
  V persistent issues
  V faction creating issues
  V faction-based issues
  V win/lose condition
  V hungry needs
  V delayed resolve issues
    
  - build some issue decks
  - define some resource types
  - multi-resources
  - allow viewing of complex types
  - create some factions with assigned decks
  - work on a proper UI, with scrolling probably
  - create proper graphics
  - underlying issues that create story?
  - multi-faction related issues
  - collect potential cards in hand (edicts and laws and stuff)
]]
if arg[#arg] == "-debug" then debug = true else debug = false end
if debug then require("mobdebug").start() end

require "draw"
require "resource"
require "reward"
require "issue"
require "faction"
require "validation"

function love.load()
  currentSeason = 1
  seasons = { "spring", "summer", "autumn", "winter" }
  
  issues = {}
  resources = {
    newResource("wealth"),
    newResource("wealth"),
    newResource("wealth", true),
    newResource("might"),
    newResource("might"),
    newResource("might"),    
  }
  score = 0
  mouse = { x = 0, y = 0 }
  selectedResource = {}
  
  factions = {}
  
  local factionData = require "factions/factions"
  for k, factionToMake in ipairs(factionData) do
    table.insert( factions, buildFactionFromTable(factionToMake) )
  end
  

  function findFactionByIdentifier(id)
    for k, v in ipairs(factions) do
      if v.identifier == id then
        return v
      end
    end
    error("Could not find faction: " .. id)
  end
  
  convert( require "decks/peasants" )
  convert( require "decks/guilds" )

  
  gameOver = false
  
end

function convert(potentialData)
  for k, potentialToMake in ipairs(potentialData) do
    local potential = buildPotentialFromTable(potentialToMake)    
    findFactionByIdentifier(potentialToMake.faction):addPotential(potential)
  end
end

function love.update(dt)  
end

function love.draw(dt)
  
  if gameOver then
    love.graphics.print("The game has ended. Your score is: " .. score, 300, 300 )
    return
  end
  
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

end

function revealNewOpportunities()

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

function simplecopy(t)
  local new = {}
  for key, value in pairs(t) do
    if type(value) == "table" then
      new[key] = simplecopy(value)
    else
      new[key] = value
    end
  end
  return new
end