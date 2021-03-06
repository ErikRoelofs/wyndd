--[[ issues for the peasant faction ]]--

-- problems
  -- uprising
  -- hunger
  -- crop death (pests, draught, disease)
  -- banditry
  -- land disputes
  -- not paying tax

-- opportunities
  -- harvest feast
  -- bountiful harvest
  -- draft
  -- taxation
  -- land expansion
  -- structures (mills, bakeries, granaries, etc)
  -- new crops
  -- animal related
  
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
    validator = { "arithmetic", "peasants", "standing", 3, "<" },
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
    validator = { "OR", {{ "seasonal", "autumn" }, { "seasonal", "summer" }}},
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
      losses = {},
      repeats = 4,
      delayed = 3
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
    identifier = "peasant_build_barn",
    issue = {
      type = "opportunity",
      name = "Raise a Barn",
      needs = { {"wealth"} },
      gains = {{"score", 3}},
      losses = {},
      repeats = 2,      
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
  {
    identifier = "peasant_cropdeath",
    issue = {
      type = "problem",
      name = "Withering crops",
      needs = { {"faith"}, {"wealth"} },
      gains = {{"score", 5}},
      losses = {{"power", "peasants", -1}, {"lose_resource", "food"}}
    },
    validator = { "seasonal", "spring" },
    faction = "peasants"
  },
  {
    identifier = "peasant_cropdeath2",
    issue = {
      type = "problem",
      name = "Swarms of Locust",
      needs = { {"faith"}, {"wealth"}, {"wealth"}, {"food"} },
      gains = {{"score", 25}},
      losses = {{"power", "peasants", -2}, {"lose_resource", "food"}, {"lose_resource", "food"}}
    },
    validator = { "AND", {{"rare"}, {"seasonal", "spring"} }},
    faction = "peasants"
  },
  {
    identifier = "peasant_landdispute",
    issue = {
      type = "problem",
      name = "Land disputes",
      needs = { {"official"},{"might"} },
      gains = {{"score", 10}, {"standing", "peasants", 1}},
      losses = {{"score", -10}, {"power", "peasants", -1}},
      repeats = 3,
      delayed = 4
    },
    validator = { "rare" },
    faction = "peasants"
  }
}

return potentials