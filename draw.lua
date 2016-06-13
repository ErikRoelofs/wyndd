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
    love.graphics.print(issue.name, x + 15, y + 2 )
    
    if issue:metNeeds() then
      love.graphics.setColor(0,255,0,255)
    else
      love.graphics.setColor(255,0,0,255)
    end
    love.graphics.rectangle("fill", x+3,y+3, 5, 5)
    
    local timeInfo = ''
    
    if issue.repeats > 1 then
      timeInfo = timeInfo .. "r: " .. issue.repeats .. "x"
    end
    if issue.repeats > 1 and issue.delayed > 1 then
      timeInfo = timeInfo .. " / "
    end
    if issue.delayed > 1 then
      timeInfo = timeInfo .. "d: " .. issue.delayed .. "x"
    end
  
    love.graphics.setColor(255,255,255,255)
    love.graphics.print(timeInfo, x, y+135)

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