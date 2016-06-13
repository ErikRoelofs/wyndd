issueList = {}

function newIssue(issueType, name, needs, gains, losses, repeats, persistent, delayed)  
  needs = simplecopy(needs)
  gains = simplecopy(gains)
  losses = simplecopy(losses)
  
  return {
    type = issueType,
    name = name,
    needs = needs,
    gains = gains,
    losses = losses,
    repeats = repeats or 1,
    delayed = delayed or 1,
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
        if self.delayed > 1 then
          self.delayed = self.delayed - 1
          self:clean()
        else
          for k, loss in ipairs(self.losses) do
            loss:resolve()
            if self.persistent then
              self:clean()
            end
          end
        end
      end
    end,
    metNeeds = function(self)
      local met = true
      for k, need in ipairs(self.needs) do
        met = met and need.met
      end
      return met
    end,
    give = function(self, resource)
      for _, want in ipairs(self.needs) do
        if not want.met and want.type == resource.type then
          want.met = true
          if not want.hungry then
            table.insert(self.resources, resource)
          end
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

function newPotential(issueFunction, validator)
  return {
    issueFunction = issueFunction,
    validator = validator,
    isValid = function(self)
      return self:validator()
    end,
    getIssue = function(self)
      return self.issueFunction()
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

function buildPotentialFromTable(table)
  local validator = buildValidatorFromTable(table.validator)
  local issueFunction = buildIssueFunctionFromTable(table.issue)
  issueList[table.identifier] = issueFunction
  return newPotential(issueFunction, validator)
end

function buildIssueFunctionFromTable(table)      
    local needs = buildNeedsFromTable(table.needs)
    local gains = buildRewardsFromTable(table.gains)
    local losses = buildRewardsFromTable(table.losses)
    
    return function()
      return newIssue(table.type, table.name, needs, gains, losses, table.repeats, table.persistent, table.delayed)
    end
end

function findIssueFunctionByIdentifier(identifier)
  if issueList[identifier] then
    return issueList[identifier]
  end
  error("No such issue: " .. identifier)
end