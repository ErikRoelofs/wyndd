--[[  
  - build some issue decks  
  - work on a proper UI, with scrolling probably < using renderer
  - make multi-option issues a thing
  
  issues:
  - receiving multiple copies of certain issues at the same time is a problem (ie; "new faction" x2)
  
  - multi-resources
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
require "option"

function love.load()
    
  seasons = { "spring", "summer", "autumn", "winter" }  
  year = 0
  currentSeason = 1
  
  resourceLookup = {}
  issueLookup = {}
    
  baseIssueFactory = issueFactory({})
    
  flags = {}
    
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
    newResource("official"),    
    newResource("food"),
    newResource("food"),
  }
  score = 0
  mouse = { x = 0, y = 0 }
  
  scoreText = { value = "Score: " .. getScore() }
  currentTurnText = { value = getSeason() .. ", year " .. year }
  
  selectedResource = {}
  
  factions = {}
  availableFactions = {}
  
  local factionData = require "factions/factions"
  for k, factionToMake in ipairs(factionData) do
    local faction = buildFactionFromTable(factionToMake)
    if factionToMake.initial then
      table.insert( factions, faction )
    end
    availableFactions[faction.identifier] = faction  
  end
  
  function isFactionAvailable(id)
    for k, v in ipairs(factions) do
      if v.identifier == id then
        return true
      end
    end
    return false
  end
  
  function findFactionByIdentifier(id)
    assert(availableFactions[id], "Could not find faction: " .. id)
    return availableFactions[id]
  end
  
  --convert( require "decks/peasants" )
  --convert( require "decks/guilds" )
  --convert( require "decks/priests" )
  convertBase( require "decks/base" )
  

  gameOver = false
  
  lc:register("issue", require "layout/issue"(lc))
  lc:register("need", require "layout/need"(lc))
  lc:register("resource", require "layout/resource"(lc))
  lc:register("indicator", require "layout/indicator"(lc))
  lc:register("faction", require "layout/faction"(lc))
  lc:register("issuecompletion", require "layout/issuecompletion"(lc))
  lc:register("option", require "layout/option"(lc))
  
  stackView = lc:build("stackroot", {})
  root = lc:build("linear", {width = "fill", height="fill", direction="v"})
  stackView:addChild(root)
  
  local layout = lc:build("linear", {width = "fill", height = 25, backgroundColor = {105,205,55,100}, direction = "h"})
  
  local score = lc:build("text", {width = 200, height = "fill", data = scoreText, textColor = {255,255,255,255}, padding = lc.padding(5,5,5,5)})
  layout:addChild(score)
  local turn = lc:build("text", {width = 200, height = "fill", data = currentTurnText, textColor = {255,255,255,255}, padding = lc.padding(5,5,5,5)})
  layout:addChild(turn)
  endTurnButton = lc:build("text", {width=200, height="fill", data = function() return "End the turn" end, backgroundColor = { 100, 100, 100, 255 }, border = { color = { 125, 125, 125, 255 }, thickness = 2 }, gravity = {"center", "center"}})
  layout:addChild(endTurnButton)
  returnResourcesButton = lc:build("text", {width=200, height="fill", data = function() return "Return resources" end, backgroundColor = { 100, 100, 100, 255 }, border = { color = { 125, 125, 125, 255 }, thickness = 2 }, gravity = {"center", "center"}})
  layout:addChild(returnResourcesButton)
  
  issueView = lc:build("linear", {width="fill", height="fill", direction="h", backgroundColor = {100,200,50,100}, padding = lc.padding(5), weight=2})
  resourceView = lc:build("linear", {width="fill", height="fill", direction="h", backgroundColor = {95,195,45,100}, padding = lc.padding(5)})
  factionView = lc:build("linear", {width="fill", height="fill", direction="h", backgroundColor = {90,190,40,100}, padding = lc.padding(5)})
  
  root:addChild(layout)
  root:addChild(issueView)
  root:addChild(resourceView)
  root:addChild(factionView)
  
  dragbox = lc:build("dragbox", {width="fill", height="fill"})
  stackView:addChild(dragbox)
  
  stackView:layoutingPass()
  
  endTheTurn()
end

function convert(potentialData)
  for k, potentialToMake in ipairs(potentialData) do
    local potential = buildPotentialFromTable(potentialToMake)    
    findFactionByIdentifier(potentialToMake.faction):addPotential(potential)
  end
end

function convertBase(potentialData)
  for k, potentialToMake in ipairs(potentialData) do
    local potential = buildPotentialFromTable(potentialToMake)    
    baseIssueFactory:addPotential(potential)
  end
end

function love.update(dt)  
  scoreText.value = "Score: " .. getScore()
  currentTurnText.value = getSeason() .. ", year " .. year
  stackView:update(dt)
  if selectedResource.key then
    dragbox.offset = { love.mouse.getX(), love.mouse.getY() }
  end
end

function love.draw(dt)
  if gameOver then
    love.graphics.print("game over", 50, 50)
    love.graphics.print("final score: " .. score , 50, 70)
    love.graphics.print("final turn: " .. getSeason() .. ", year: " .. getYear(), 50, 90)
  else
    stackView:render()
  end
end

function love.keypressed(key, scancode)
  if key == "q" and not gameOver then
    endTheTurn()
  end
end

function dropit()
  dragbox:removeChild(selectedResource.view)
  resourceView:addChild(selectedResource.view)
  selectedResource = {}  
end

function love.mousepressed(x, y, button)
  
  
  mouse.x = x
  mouse.y = y
      
  local list = root:clickedViews(x,y)
  for k, v in ipairs(list) do
    if resourceLookup[v] then
      if not resourceLookup[v].resource.used then
        if selectedResource.key then
          dropit()
        end
        
        local selected = resourceLookup[v]
        for k, v in ipairs(resources) do
          if v == selected.resource then
            selected.key = k
          end
        end
        selectedResource = selected
        resourceView:removeChild(v)
        dragbox:addChild(v)
        return
      end
    end
  end

  if selectedResource.key then
    for k, v in ipairs(list) do
      if issueLookup[v] then
        local issue = issueLookup[v]
        if issue:give(selectedResource.resource) then          
          table.remove( resources, selectedResource.key )
          dragbox:removeChild(selectedResource.view)
          selectedResource.resource.used = true
          selectedResource = {}          
          return
        end
      end
    end
  end
  
  if not selectedResource.key then
    for k, v in ipairs(list) do
      if issueLookup[v] then
        issueLookup[v]:returnResources(true)
        redrawResources()
        issueLookup[v]:selectNextOption()        
      end
    end
  end
  
  for k, v in ipairs(list) do
    if v == endTurnButton then
      endTheTurn()
      return
    end
  end

  for k, v in ipairs(list) do
    if v == returnResourcesButton then
      returnAllResources(true)
      return
    end
  end



  if selectedResource.key then
    dropit()
    return
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
  if selectedResource.key then
    dropit()
  end
  
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
    issue:markDone()
  end
  for _, issue in ipairs(issues) do
    if issue:isDone() then
      issue:resolve()
    end
  end
  
end

function revealNewIssues()
  
  issueView:removeAllChildren()
  issueLookup = {}

  local maybe = baseIssueFactory:getValidIssue()
  if maybe then
    table.insert(issues, maybe)
  end

  for k, faction in ipairs(factions) do
    faction:revealNewIssues()    
  end
  
  for k, issue in ipairs(issues) do
    local child = makeViewForIssue(lc, issue)
    issueView:addChild(child)
    issueLookup[child] = issue
  end
  
end

function returnAllResources(evenConsumables)
  evenConsumables = evenConsumables or false
  
  for i, issue in ipairs(issues) do
    issue:returnResources(evenConsumables)
  end
  redrawResources()
  
end

function redrawResources()
  resourceLookup = {}
  resourceView:removeAllChildren()
  
  for k, r in ipairs(resources) do
    local child = lc:build("resource", r)
    resourceView:addChild(child)
    resourceLookup[child] = {resource = r, view = child}
    resourceView:layoutingPass()
  end
  
end

function checkWinLose()

end

function backToAssignPhase()
  stackView:layoutingPass()
end

function assignPhase()  
end

function cleanup()  
  cleanDoneIssues()
  cleanFactions()
  for k, i in ipairs(issues) do
    i:checkSelection()
  end
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
    if issues[i]:isDone() then
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

function getScore()
  return score
end