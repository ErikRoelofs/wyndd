issueList = {}

function newIssue(issueType, name, options)  
  
  return {
    type = issueType,
    name = name,
    options = options,
    resolve = function(self)
      if self:metNeeds() then
        self.repeats = self.repeats + 1
        if self.maxRepeats > self.repeats then          
          self:clean()
        else
          for k, gain in ipairs(self.gains) do
            gain:resolve()
            if self.continuous then
              self:clean()
            end
          end
        end
        self:cleanHungry()
      else
        self.delayed = self.delayed + 1
        if self.maxDelayed > self.delayed then          
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
        met = met and (need.met or false)
      end
      return met
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
    end,
    cleanHungry = function(self)
      for k, need in ipairs(self.needs) do
        if need.hungry then
          local notFound = true
          for i, resource in ipairs(self.resources) do            
            if notFound and resource.type == need.type then
              notFound = false
              table.remove(self.resources, i)              
            end
          end
        end
      end
    end,
    allNeedsNotMet = function(self)
      for k, need in ipairs(self.needs) do
        need.met = false
      end      
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

function buildIssueFunctionFromTable(issueTable)      
    local options = buildOptionsFromTable(issueTable.options)
    table.insert(options, buildDefaultFromTable(issueTable.default))
    if issueTable.ignorable then
      table.insert(options, buildIgnoreFromTable(issueTable.ignorable ))
    end
    
    return function()
      return newIssue(issueTable.type, issueTable.name, options)
    end
end

function findIssueFunctionByIdentifier(identifier)
  if issueList[identifier] then
    return issueList[identifier]
  end
  error("No such issue: " .. identifier)
end