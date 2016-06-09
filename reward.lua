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

function newIssueReward(issueFunction)
  return {
    issueFunction = issueFunction,    
    resolve = function(self) 
      table.insert(issues, self.issueFunction())
    end,
    draw = function(self, x, y)
      love.graphics.print( "A new issue", x, y)
    end
  }
end

function newFactionReward(faction)
  return {
      faction = faction,
      resolve = function(self)
        table.insert(factions, self.faction)
      end,
      draw = function(self,x,y)
        love.graphics.print("A new faction", x, y)
      end
  }
end

function newGameOverReward()
  return {
    resolve = function(self)
      gameOver = true
    end,
    draw = function(self,x,y)
      love.graphics.print("The game ends.", x,y)
    end
  }
end

function buildRewardsFromTable(t)
  local rewards = {}
  for _, reward in ipairs(t) do
    table.insert(rewards, buildRewardFromTable(reward))
  end
  return rewards
end

function buildRewardFromTable(table)
  if table[1] == "score" then
    return newScoreReward(table[2])
  elseif table[1] == "game_end" then
    return newGameOverReward()
  elseif table[1] == "power" then
    return newPowerReward(findFactionByIdentifier(table[2]), table[3])
  elseif table[1] == "issue" then
    return newIssueReward(findIssueFunctionByIdentifier(table[2]))
  else
    error("Unknown type of reward: " .. table[1])
  end
end