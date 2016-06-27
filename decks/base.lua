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
    identifier = "base_example",
    issue = {
      type = "opportunity",
      name = "Example",
      needs = { {"might"}, {"might"}, {"might"}, {"might"} },
      gains = {{"power", "peasants", -3}},
      losses = {{"game_end"}},
      delayed = 3,
    },
    validator = { "always" },
    faction = "base"
  },
}

return potentials