--[[
  peasants
  nobles
  guilds
  religions
  
  
  ===
  
  bandits
  neighbouring kingdoms

]]--

local factions = {
    {
      identifier = "peasants",
      name = "Peasants",
      standing = 5,
      power = 5,
      initial = true,
    },
    {
      identifier = "guilds",
      name = "Guilds",
      standing = 5,
      power = 5,
      initial = true,
    },
    {
      identifier = "priests",
      name = "Priests",
      standing = 5,
      power = 5,
      initial = true
    },
    {
      identifier = "nobles",
      name = "Nobles",
      standing = 5,
      power = 5,
      initial = false
    },
    {
      identifier = "bandits",
      name = "Bandits",
      standing = 1,
      power = 5,
      initial = false
    },
    {
      identifier = "thieves",
      name = "Dark Brotherhood",
      standing = 3,
      power = 3,
      initial = false
    },
    {
      identifier = "neighbour1",
      name = "Neighbouring Kingdom",
      standing = 5,
      power = 5,
      initial = false
    },
    {
      identifier = "neighbour2",
      name = "Neighbouring Kingdom",
      standing = 5,
      power = 5,
      initial = false
    },
    {
      identifier = "neighbour3",
      name = "Neighbouring Kingdom",
      standing = 5,
      power = 5,
      initial = false
    },
    {
      identifier = "neighbour4",
      name = "Neighbouring Kingdom",
      standing = 5,
      power = 5,
      initial = false
    },
    {
      identifier = "plague",
      name = "The Black Plague",
      standing = 1,
      power = 10,
      initial = false
    }
}

return factions