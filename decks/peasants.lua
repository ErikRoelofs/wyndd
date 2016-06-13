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

--function newIssue(issueType, needs, gains, losses, repeats, persistent, delayed)

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
    validator = { "arithmetic", "peasants", "standing", 8, "<" },
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
  }
}

return potentials