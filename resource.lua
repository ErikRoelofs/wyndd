function newResource(type, consumable)
  return {
    type = type,
    consumable = consumable or false
  }
end

function newNeed(type, hungry)
  return {
    type = type,
    hungry = hungry or false
  }
end

function buildResourceFromTable(table)
  
end

function buildNeedFromTable(table)
  return newNeed(table[1], table[2])
end

function buildNeedsFromTable(t)
  local needs = {}
  for _, need in ipairs(t) do
    table.insert(needs, buildNeedFromTable(need))
  end
  return needs
end