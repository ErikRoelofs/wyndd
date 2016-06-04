function newResource(type)
  return {
    type = type
  }
end

function newWant(type, hungry)
  return {
    type = type,
    hungry = hungry or false
  }
end