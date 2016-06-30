issueList = {}

function newIssue(issueType, name, options)  
  
  return {
    type = issueType,
    name = name,
    options = options,
    selected = 1,--#options,
    resolve = function(self)
      self.options[self.selected]:resolve()
    end,
    returnResources = function(self, allOfThem)
      self.options[self.selected]:returnResources(allOfThem)
    end,
    give = function(self, resource)
      return self.options[self.selected]:give(resource)
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