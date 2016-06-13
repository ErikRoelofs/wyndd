-- offerings
-- blessings
-- feasts
-- celebrations
-- good/bad omens
-- heretics
-- shischms

local potentials = {
  {
    identifier = "priests_offering",
    issue = {
      type = "problem",
      name = "Offer a bull",
      needs = { {"faith"}, {"might"}},
      gains = {{"standing", "priests", 1}, {"standing", "peasants", -1}},
      losses = {{"standing", "priests", -1}, {"standing", "peasants", 1}},
      delayed = 2,
    },
    validator = { "seasonal", "autumn" },
    faction = "priests"
  }, 
  {
    identifier = "priests_blessing",
    issue = {
      type = "opportunity",
      name = "Give blessing",
      needs = { {"faith"}},
      gains = {{"score", 1}},
      losses = {},      
    },
    validator = { "always" },
    faction = "priests"
  }, 
}

return potentials