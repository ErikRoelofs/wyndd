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