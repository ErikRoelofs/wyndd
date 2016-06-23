function newScoreReward(value)
  return {
    value = value, 
    resolve = function() 
      score = score + value 
    end, 
    getView = function(self)
      return lc:build("text", { width = "wrap", height = "wrap", data = self.getText })
    end,
    getText = function()
      if value > 0 then
        return "+" .. value .. " score"
      else
        return value .. " score"
      end 
    end
  }
end

function newResourceReward(resource)
  return {
    resource = resource, 
    resolve = function(self) table.insert(resources, self.resource) end, 
    getView = function(self) return lc:build("resource", self.resource) end
  }  
end

function newLoseResourceReward(resourceType)
  return {
    resourceType = resourceType,
    resolve = function(self) 
      for k, resource in ipairs(resources) do
        if resource.type == resourceType then
          table.remove(resources,k)
          return
        end
      end
    end,
    getView = function(self) return lc:build("text", { width = "wrap", height="wrap", data = {value = "Lose a resource:" .. self.resourceType}}) end
  }
end

function newStandingReward(faction, value)
  return {
      faction = faction,
      value = value,
      resolve = function(self) 
        faction.standing = faction.standing + value
      end,
      getView = function(self)
        return lc:build("text", { width = "wrap", height = "wrap", data = self.getText })
      end,
      getText = function()
        return value .. " standing with " .. faction.name
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
      getView = function(self)
        return lc:build("text", { width = "wrap", height = "wrap", data = self.getText })
      end,
      getText = function()
        return value .. " power for " .. faction.name
      end
  }
end

function newIssueReward(issueFunction)
  return {
    issueFunction = issueFunction,    
    resolve = function(self) 
      table.insert(issues, self.issueFunction())
    end,
    getView = function(self)
      return lc:build("text", { width = "wrap", height = "wrap", data = self.getText })
    end,
    getText = function()
      return "A new issue"
    end
  }
end

function newFactionReward(faction)
  return {
      faction = faction,
      resolve = function(self)
        table.insert(factions, self.faction)
      end,
      getView = function(self)
        return lc:build("text", { width = "wrap", height = "wrap", data = self.getText })
      end,
      getText = function()
        return "A new faction"
      end
  }
end

function newGameOverReward()
  return {
    resolve = function(self)
      gameOver = true
    end,
    getView = function(self)
      return lc:build("text", { width = "wrap", height = "wrap", data = self.getText })
    end,
    getText = function()
      return "The game ends"
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
  elseif table[1] == "standing" then
    return newStandingReward(findFactionByIdentifier(table[2]), table[3])
  elseif table[1] == "issue" then
    return newIssueReward(findIssueFunctionByIdentifier(table[2]))
  elseif table[1] == "resource" then
    return newResourceReward(newResource(table[2], table[3]))
  elseif table[1] == "loseresource" then
    return newLoseResourceReward(table[2])
  else
    error("Unknown type of reward: " .. table[1])
  end
end