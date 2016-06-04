function newResource(type, consumable)
  return {
    type = type,
    consumable = consumable or false
  }
end

function newWant(type, hungry)
  return {
    type = type,
    hungry = hungry or false
  }
end