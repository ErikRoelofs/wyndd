function andValidator(validationTable)
  local validators = {}
  for k, v in ipairs(validationTable) do
    table.insert(validators, buildValidatorFromTable(v))
  end
  
  return function()
    local all = true
    for k, v in ipairs(validators) do
      all = all and v()
    end
    return all
  end
end

function orValidator(validationTable)
  local validators = {}
  for k, v in ipairs(validationTable) do
    table.insert(validators, buildValidatorFromTable(v))
  end
  
  return function()
    local any = false
    for k, v in ipairs(validators) do
      any = any or v()
    end
    return any
  end
end

function neverValidator()
  return false
end

function alwaysValidator()
  return true
end

function rareValidator()
  return math.random(1,4) == 1
end

function arithmeticValidator(table, field, value, operator)
  return function()
    if operator == "<" then
      return table[field] < value
    elseif operator == "<=" then
      return table[field] <= value
    elseif operator == "==" then
      return table[field] == value
    elseif operator == ">=" then
      return table[field] >= value
    elseif operator == ">" then
      return table[field] > value
    end
    error("Unknown operator: " .. operator)
  end  
end

function seasonalValidator(season)
  return function()
    return getSeason() == season
  end
end

function fromYearValidator(year)
  return function()
    return getYear() >= year
  end
end

function flagIsSetValidator(flagName)
  return function()    
    return flags[flagName] ~= nil
  end
end

function flagIsNotSetValidator(flagName)
  return function()    
    return flags[flagName] == nil
  end
end

function factionExists(factionId)
  return function()
    return isFactionAvailable(factionId) end
end

function factionNotExists(factionId)
  return function()
    return not isFactionAvailable(factionId) end
end

function unique(name)
  return function()
    for k, issue in ipairs(issues) do
      if issue.name == name then
        return false
      end
    end
    return true
  end
end

function scoreValidator(score)
  return function()
    return score >= getScore()
  end
end

function buildValidatorFromTable(validator)
  if validator[1] == "never" then
    return neverValidator
  elseif validator[1] == "always" then
    return alwaysValidator
  elseif validator[1] == "rare" then
    return rareValidator
  elseif validator[1] == "arithmetic" then
    return arithmeticValidator(findFactionByIdentifier(validator[2]), validator[3], validator[4], validator[5])
  elseif validator[1] == "seasonal" then
    return seasonalValidator(validator[2])
  elseif validator[1] == "AND" then
    return andValidator(validator[2])
  elseif validator[1] == "OR" then
    return orValidator(validator[2])
  elseif validator[1] == "year" then
    return fromYearValidator(validator[2])
  elseif validator[1] == "flag_set" then
    return flagIsSetValidator(validator[2])
  elseif validator[1] == "flag_not_set" then
    return flagIsNotSetValidator(validator[2])
  elseif validator[1] == "faction_exists" then
    return factionExists(validator[2])
  elseif validator[1] == "faction_not_exists" then
    return factionNotExists(validator[2])
  elseif validator[1] == "unique" then
    return unique(validator[2])
  elseif validator[1] == "score" then
    return scoreValidator(validator[2])
  else
    error("Unknown validator type: " .. validator[1])
  end
end
