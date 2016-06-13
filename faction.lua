function newFaction(id, name, standing, power, potentials)  
  return {
      identifier = id,
      name =  name,
      standing = standing,
      power = power,
      issueFactory = issueFactory(potentials),
      addPotential = function(self, potential)
        self.issueFactory:addPotential(potential)
      end,
      revealNewIssues = function(self)
        local chance1 = self.power * 5 + 50
        if math.random(1,100) <= chance1 then
          self:reveal()
        end
        local chance2 = self.power * 5
        if math.random(1,100) <= chance2 then
          self:reveal()
        end
      end,
      reveal = function(self)
        local maybeIssue = self.issueFactory:getValidIssue()
        if maybeIssue then
          table.insert(issues, maybeIssue)
        end
      end
    }
end

function buildFactionFromTable(table)
  return newFaction(table.identifier, table.name, table.standing or 5, table.power or 5, {})
end