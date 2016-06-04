function newFaction(name, potentials)  
  return {
      name =  name,
      standing = 5,
      power = 5,
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
