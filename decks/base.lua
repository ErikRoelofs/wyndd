--[[ base issues that will always be checked (and should always generate some stuff to worry about ]]--
-- should also generate general game progressors

-- generic
    -- travelling merchants
    -- introductions of new factions
    -- laws and regulations
    -- crimes and punishment
    -- basic fears (raiding, the unknown, etc)
    
-- spring
  -- problems
  
  -- opportunities

-- summer
  -- problems
    -- draught
    -- fires
  -- opportunities

-- autumn
  -- problems
  
  -- opportunities


-- winter
  -- problems
    -- famine
    -- extreme cold
    -- 
  -- opportunities
  
  
local potentials = {
  {
    identifier = "base_population_growth",
    issue = {
      type = "opportunity",
      name = "Expanding the population",
      needs = {{"food", true}, {"food", true}},
      gains = {{"score", 50}},
      losses = {},      
    },
    validator = { "rare" },
    faction = "base"
  },

  {
    identifier = "base_rise_of_dark_brotherhood",
    issue = {
      type = "opportunity",
      name = "Rise of the Dark Brotherhood",
      needs = {},
      gains = {{"faction", "thieves"}},
      losses = {},
      repeats = 6,
    },
    validator = { "AND", {{"year", 3}, {"unique", "Rise of the Dark Brotherhood"}, {"faction_not_exists", "thieves"}}},
    faction = "base"
  },
  
}

return potentials