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
    identifier = "base_rise_of_dark_brotherhood",
    issue = {
      type = "opportunity",
      name = "Example",
      needs = {},
      gains = {{"faction", "thieves"}},
      losses = {},
      repeats = 6,
    },
    validator = { "AND", {{"year", 1}, {"unique", "Example"}, {"faction_not_exists", "thieves"}}},
    faction = "base"
  },
}

return potentials