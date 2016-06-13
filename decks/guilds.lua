-- problems

  -- strikes
  -- material shortage
  -- a new competitor
  -- poor planning
  -- theft
  -- buiding construction
  
-- opportunities
  -- a new guild
  -- a valuable trade
  -- a new technology
  -- a huge order
  
local potentials = {
  {
    identifier = "guilds_strikes",
    issue = {
      type = "problem",
      name = "Guild Strike",
      needs = { {"might"}},
      gains = {{"score", 2}},
      losses = {{"score", -5}},
      delayed = 2,
    },
    validator = { "always" },
    faction = "guilds"
  }, 
  {
    identifier = "guilds_shortages",
    issue = {
      type = "problem",
      name = "Material shortages",
      needs = { {"wealth", "wealth"}},
      gains = {{"score", 10}},
      losses = {{"power", "guilds", -1}},      
    },
    validator = { "always" },
    faction = "guilds"
  },   
  {
    identifier = "guilds_new_trade_route",
    issue = {
      type = "opportunity",
      name = "A new trade route",
      needs = { {"wealth"}, {"wealth"}, {"might"}},
      gains = {{"score", 20}, {"resource", "wealth"}},
      losses = {{"standing", "guilds", -2}},
      repeats = 5,
      delayed = 3,
    },
    validator = { "rare" },
    faction = "guilds"
  },   
  {
    identifier = "guilds_build_cathedral",
    issue = {
      type = "opportunity",
      name = "Build a cathedral",
      needs = { {"wealth"}, {"wealth"}},
      gains = {{"score", 100}},
      losses = {{"standing", "guilds", -2}},
      repeats = 10,
      delayed = 5,
    },
    validator = { "rare" },
    faction = "guilds"
  },
  
}

return potentials