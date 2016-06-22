--[[
  V chained issues
  V multi-turn issues
  V persistent issues
  V faction creating issues
  V faction-based issues
  V win/lose condition
  V hungry needs
  V delayed resolve issues
    
  - create some factions with assigned decks
  - build some issue decks
  - define some resource types
  - work on a proper UI, with scrolling probably < using renderer
  
  - multi-resources
  - allow viewing of complex types
  - create proper graphics
  - underlying issues that create story?
  - multi-faction related issues
  - collect potential cards in hand (edicts and laws and stuff)
]]
if arg[#arg] == "-debug" then debug = true else debug = false end
if debug then require("mobdebug").start() end

lc = require "renderer"

require "draw"
require "resource"
require "reward"
require "issue"
require "faction"
require "validation"

function love.load()
    
  seasons = { "spring", "summer", "autumn", "winter" }  
  year = 0
  currentSeason = 1
    
    
  font = love.graphics.newFont()
  
  issues = {}
  resources = {
    newResource("wealth"),
    newResource("wealth"),
    newResource("wealth", true),
    newResource("might"),
    newResource("might"),
    newResource("might"),    
    newResource("faith"),    
  }
  score = 0
  mouse = { x = 0, y = 0 }
  
  scoreText = { value = "Score: " .. score }
  currentTurnText = { value = getSeason() .. ", year " .. year }
  
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
  convert( require "decks/priests" )

  gameOver = false
  
  lc:register("issue", require "layout/issue"(lc))
  lc:register("need", require "layout/need"(lc))
  lc:register("resource", require "layout/resource"(lc))
  lc:register("indicator", require "layout/indicator"(lc))
  lc:register("faction", require "layout/faction"(lc))
  
  root = lc:build("root", {direction="v"})
  
  local layout = lc:build("linear", {width = "fill", height = 25, backgroundColor = {105,205,55,100}, direction = "h"})
  
  local score = lc:build("text", {width = 200, height = "fill", data = scoreText, textColor = {255,255,255,255}, padding = lc.padding(5,5,5,5)})
  layout:addChild(score)
  local turn = lc:build("text", {width = 200, height = "fill", data = currentTurnText, textColor = {255,255,255,255}, padding = lc.padding(5,5,5,5)})
  layout:addChild(turn)
  
  issueView = lc:build("linear", {width="fill", height="fill", direction="h", backgroundColor = {100,200,50,100}, padding = lc.padding(5), weight=2})
  resourceView = lc:build("linear", {width="fill", height="fill", direction="h", backgroundColor = {95,195,45,100}, padding = lc.padding(5)})
  factionView = lc:build("linear", {width="fill", height="fill", direction="h", backgroundColor = {90,190,40,100}, padding = lc.padding(5)})
  
  root:addChild(layout)
  root:addChild(issueView)
  root:addChild(resourceView)
  root:addChild(factionView)
  
  root:layoutingPass()
end

function convert(potentialData)
  for k, potentialToMake in ipairs(potentialData) do
    local potential = buildPotentialFromTable(potentialToMake)    
    findFactionByIdentifier(potentialToMake.faction):addPotential(potential)
  end
end

function love.update(dt)  
  scoreText.value = "Score: " .. score
  currentTurnText.value = getSeason() .. ", year " .. year
  root:update(dt)
end

function love.draw(dt)
  root:render()
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

function getYear()
  return year
end


function nextSeason()
  if currentSeason < #seasons then
    currentSeason = currentSeason + 1
  else
    year = year + 1
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
  
  issueView:removeAllChildren()

  for k, faction in ipairs(factions) do
    faction:revealNewIssues()    
  end
  
  for k, issue in ipairs(issues) do
    issueView:addChild(makeViewForIssue(lc, issue))
  end
  
end

function returnAllResources()
  
  resourceView:removeAllChildren()
  
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
  
  for k, r in ipairs(resources) do
    resourceView:addChild(lc:build("resource", r))
  end
  
end

function checkWinLose()

end

function backToAssignPhase()
  root:layoutingPass()
end

function assignPhase()  
end

function cleanup()  
  cleanDoneIssues()
  cleanFactions()
end

function cleanFactions()
  
  factionView:removeAllChildren()
  
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
  
  for k, faction in ipairs(factions) do
    factionView:addChild( lc:build("faction", {name = faction.name, power = faction.power, standing = faction.standing}))
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