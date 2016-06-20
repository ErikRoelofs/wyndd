function drawFaction(faction, x, y)
  
  love.graphics.setColor(255,255,255,255)
  love.graphics.print(faction.name, x, y)
  love.graphics.print("standing: " .. faction.standing, x, y + 15)
  love.graphics.print("power: " .. faction.power, x, y + 30)
  
end

function makeViewForIssue(lc, issue)
    
    return lc:build("issue", { type = issue.type, name = issue.name, needs = issue.needs, gains = issue.gains, losses = issue.losses, repeats = issue.repeats, persistent = issue.persistent, delayed = issue.delayed, metNeeds = issue:metNeeds()  } )
    
end

function makeViewForNeed(need)
  
  local bgColor = {}
  if need.type == "wealth" then
    bgColor = {0,200,150,255}
  elseif need.type == "might" then
    bgColor = {100,100,100,255}
  elseif need.type == "food" then
    bgColor = {0,200,0,255}
  elseif need.type == "faith" then
    bgColor = {250,150,150,255}
  end
  
  met = {}
  if need.met then
    met = {0,255,0,255}
  else
    met = {255,0,0,255}
  end
 
  local view = lc:build("linear", {height=20, width=20, backgroundColor = bgColor, margin=lc.margin(5, 2)})
  view:addChild(lc:build("linear", {height=5, width=5, backgroundColor = met, border={color={255,255,255,255}, thickness=1 }, padding=lc.padding(10,2,2,10)}))
  return view
end

function drawNeed(need, x, y)
  if need.type == "wealth" then
    love.graphics.setColor(0,200,150,255)
  elseif need.type == "might" then
    love.graphics.setColor(100,100,100,255)
  elseif need.type == "food" then
    love.graphics.setColor(0,200,0,255)
  elseif need.type == "faith" then
    love.graphics.setColor(250,150,150,255)
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
  elseif resource.type == "food" then
    love.graphics.setColor(0,200,0,255)
  elseif resource.type == "faith" then
    love.graphics.setColor(250,150,150,255)
  end
  if resource.consumable then
    love.graphics.circle("fill", x  + 7.5, y + 7.5, 7.5)
  else
    love.graphics.rectangle("fill", x, y, 15,15)
  end
end

function drawGain(gain, x, y)
  love.graphics.setColor(255,255,255,255)
  gain:draw(x,y)
end

function drawLoss(loss, x, y)
  love.graphics.setColor(255,255,255,255)
  loss:draw(x,y)
end