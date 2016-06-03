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

function newIssueReward(issue)
  return {
    issue = issue,    
    resolve = function(self) 
      table.insert(issues, self.issue)
    end,
    draw = function(self, x, y)
      love.graphics.print( "A new issue", x, y)
    end
  }
end