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
      options = {
        {
          name = "Give out the food, grow the populace",
          needs = {{"food", true}, {"food", true}},
          gains = {{"score", 100}},
          times = 2,
        }
      },      
      default = {
        name = "No food for you.",
        gains = {}
      },
      ignorable = {
        times = 3,
        gains = {{"score", -1}}
      }
    },
    validator = { "always" },
    faction = "base"
  },

  --[[
  {
    identifier = "base_population_growth",
    issue = {
      type = "opportunity",
      name = "Expanding the population",
      needs = {{"food", true}, {"food", true}},
      gains = {{"score", 100}},
      losses = {},      
    },
    validator = { "rare" },
    faction = "base"
  },
  {
    identifier = "base_investments",
    issue = {
      type = "opportunity",
      name = "Investing in the future",
      needs = {{"wealth", true}, {"wealth", true}},
      gains = {{"score", 100}},
      losses = {},      
    },
    validator = { "rare" },
    faction = "base"
  },
  {
    identifier = "base_fortifications",
    issue = {
      type = "opportunity",
      name = "Permanent fortifications",
      needs = {{"might", true}, {"might", true}},
      gains = {{"score", 100}},
      losses = {},      
    },
    validator = { "rare" },
    faction = "base"
  },
  {
    identifier = "base_celebrations",
    issue = {
      type = "opportunity",
      name = "Religious celebrations",
      needs = {{"faith", true}, {"faith", true}},
      gains = {{"score", 100}},
      losses = {},      
    },
    validator = { "rare" },
    faction = "base"
  },
  {
    identifier = "base_nobles",
    issue = {
      type = "opportunity",
      name = "The nobility arrives",
      needs = {},
      gains = {{"faction", "nobles"}},
      losses = {},
      repeats = 3,
    },
    validator = { "AND", {{"year", 2}, {"unique", "The nobility arrives"}, {"faction_not_exists", "nobles"}}},
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
    validator = { "AND", {{"year", 5}, {"unique", "Rise of the Dark Brotherhood"}, {"faction_not_exists", "thieves"}}},
    faction = "base"
  },
  {
    identifier = "base_plague",
    issue = {
      type = "problem",
      name = "A plague in the east",
      needs = {},
      gains = {{"faction", "plague"},{"flag", "plague"}},
      losses = {},
      repeats = 6,
    },
    validator = { "AND", {{"year", 8}, {"unique", "A plague in the east"}, {"flag_not_set", "plague"}}},
    faction = "base"
  },
  ]]
}

return potentials