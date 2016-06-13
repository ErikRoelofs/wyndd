--[[ issues for the peasant faction ]]--

-- problems
  -- uprising
  -- hunger
  -- crop death (pests, draught, disease)
  -- banditry
  -- land disputes

-- opportunities
  -- harvest feast
  -- bountiful harvest
  -- draft
  -- taxation
  -- land expansion
  -- structures (mills, food production, granaries, etc)
  -- new crops
  
local potentials = {
  {
    identifier = "peasant_riot_3",
    issue = {
      type = "problem",
      name = "Peasant revolt",
      needs = { {"might"}, {"might"}, {"might"}, {"might"} },
      gains = {{"power", "peasants", -3}},
      losses = {{"game_end"}},
      delayed = 3,
    },
    validator = { "never" },
    faction = "peasants"
  },
  {
    identifier = "peasant_riot_2",
    issue = {
      type = "problem",
      name = "Peasant uprising",
      needs = { {"might"}, {"might"}, {"might"} },
      gains = {{"power", "peasants", -2}},
      losses = {{"score", -10}, {"issue", "peasant_riot_3"}},
      delayed = 3,
    },
    validator = { "never" },
    faction = "peasants"
  },
  {
    identifier = "peasant_riot_1",
    issue = {
      type = "problem",
      name = "Peasant riot",
      needs = { {"might"}, {"might"} },
      gains = {{"power", "peasants", -1}},
      losses = {{"score", -5}, {"issue", "peasant_riot_2"}},
      delayed = 3,
    },
    validator = { "arithmetic", "peasants", "standing", 5, "<" },
    faction = "peasants"
  },
  {
    identifier = "peasant_hunger",
    issue = {
      type = "problem",
      name = "Famine",
      needs = { {"food"} },
      gains = {{"standing", "peasants", 1}},
      losses = {{"power", "peasants", -1}}
    },
    validator = { "seasonal", "winter" },
    faction = "peasants"
  },
  {
    identifier = "peasant_good_harvest",
    issue = {
      type = "opportunity",
      name = "Bountiful Harvest",
      needs = { {"might"} },
      gains = {{"resource", "food", true}},
      losses = {{"standing", "peasants", 1}}
    },
    validator = { "seasonal", "autumn" },
    faction = "peasants"
  },
  {
    identifier = "peasant_festivities",
    issue = {
      type = "opportunity",
      name = "Summer Festivities",
      needs = { {"wealth"} },
      gains = {{"power", "peasants", 1}},
      losses = {}
    },
    validator = { "seasonal", "summer" },
    faction = "peasants"
  },  
  {
    identifier = "peasant_militia",
    issue = {
      type = "opportunity",
      name = "Raise Militia",
      needs = { {"wealth"} },
      gains = {{"power", "peasants", -1}, {"resource", "might"}},
      losses = {}
    },
    validator = { "arithmetic", "peasants", "power", 5, ">" },
    faction = "peasants"
  },
  {
    identifier = "peasant_draft",
    issue = {
      type = "opportunity",
      name = "Draft soldiers",
      needs = { {"might"}, {"might"} },
      gains = {{"power", "peasants", -1}, {"standing", "peasants", -1}, {"resource", "might"}},
      losses = {}
    },
    validator = { "arithmetic", "peasants", "power", 3, ">" },
    faction = "peasants"
  }, 
  {
    identifier = "peasant_expand_land",
    issue = {
      type = "opportunity",
      name = "Expand farmlands",
      needs = { {"might"}, {"wealth"} },
      gains = {{"power", "peasants", 1}, {"score", 5}},
      losses = {}
    },
    validator = { "rare" },
    faction = "peasants"
  },
  {
    identifier = "peasant_taxation",
    issue = {
      type = "opportunity",
      name = "Hefty taxation",
      needs = { {"might"}, {"might"} },
      gains = {{"standing", "peasants", -2}, {"resource", "wealth"}},
      losses = {}
    },
    validator = { "always" },
    faction = "peasants"
  },
  {
    identifier = "peasant_build_mill",
    issue = {
      type = "opportunity",
      name = "Build a Mill",
      needs = { {"wealth"}, {"wealth"} },
      gains = {{"standing", "peasants", 1}, {"resource", "food"}},
      losses = {},
      repeats = 3,
      delayed = 3,
    },
    validator = { "always" },
    faction = "peasants"
  },
 {
    identifier = "peasant_bandits",
    issue = {
      type = "problem",
      name = "Bandit activity",
      needs = { {"might"}, {"might"} },
      gains = {{"standing", "peasants", 1}, {"score", 10}},
      losses = {{"score", -5}, {"standing", "peasants", -1}},
      persistent = true,
      repeats = 2
    },
    validator = { "always" },
    faction = "peasants"
  },
    
}

return potentials