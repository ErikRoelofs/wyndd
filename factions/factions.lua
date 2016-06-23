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
      initial = false,
    },
    {
      identifier = "priests",
      name = "Priests",
      standing = 5,
      power = 5,
      initial = true
    }
}

return factions