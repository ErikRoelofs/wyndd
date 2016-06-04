function newIssue(issueType, needs, gains, losses, repeats, persistent)
  return {
    type = issueType,
    needs = needs,
    gains = gains,
    losses = losses,
    repeats = repeats or 1,
    persistent = persistent or false,
    resources = {},
    resolve = function(self)
      if self:metNeeds() then
        if self.repeats > 1 then
          self.repeats = self.repeats - 1
          self:clean()
        else
          for k, gain in ipairs(self.gains) do
            gain:resolve()
          end
        end
      else        
        for k, loss in ipairs(self.losses) do
          loss:resolve()
          if self.persistent then
            self:clean()
          end
        end
      end
    end,
    metNeeds = function(self)
      return #self.needs == #self.resources 
    end,
    give = function(self, resource)
      for _, want in ipairs(self.needs) do
        if not want.met and want.type == resource.type then
          want.met = true
          table.insert(self.resources, resource)
          return true
        end
      end
      return false
    end,
    clean = function(self)
      for k, need in ipairs(self.needs) do
        need.met = false
      end
      self.done = false
    end
  }
end

function newPotential(issue, validator)
  return {
    issue = issue,
    validator = validator,
    isValid = function(self)
      return self:validator()
    end,
    getIssue = function(self)
      return self.issue
    end    
  }
end

function issueFactory(potentials)
  return {
    potentials = potentials,
    getValidIssue = function(self)
      local toPickFrom = {}
      for k, potential in ipairs(self.potentials) do
        if potential:isValid() then
          table.insert(toPickFrom, potential)
        end        
      end
      if #toPickFrom == 0 then
        return
      end
      local num = math.random(1, #toPickFrom)
      return toPickFrom[num]:getIssue()
    end,
    addPotential = function(self, potential)
      table.insert(self.potentials, potential)
    end,
  }
end