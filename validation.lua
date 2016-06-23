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
  else
    error("Unknown validator type: " .. validator[1])
  end
end
