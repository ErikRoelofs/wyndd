issueList = {}

function newIssue(issueType, name, options)  
  options = simplecopy(options)
  local issue = {
    type = issueType,
    name = name,
    options = options,
    selected = 1,
    resolve = function(self)
      local isDone = self.options[self.selected]:resolve()
      if not isDone then
        self:markNotDone()
      end
    end,
    returnResources = function(self, allOfThem)
      self.options[self.selected]:returnResources(allOfThem)
    end,
    give = function(self, resource)
      return self.options[self.selected]:give(resource)
    end,
    selectNextOption = function(self)
      if self.selected == #self.options then
        self.selected = 1
      else
        self.selected = self.selected + 1        
      end
      if not self.options[self.selected]:canSelect() then
        self:selectNextOption()
      end
    end,
    checkSelection = function(self)
      if not self.options[self.selected]:canSelect() then
        self:selectNextOption()
      end      
    end,
    markDone = function(self)
      self.done = true
    end,
    markNotDone = function(self)
      self.done = false
    end,
    isDone = function(self)
      return self.done
    end,
    done = false
  }
  issue:checkSelection()
  return issue
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