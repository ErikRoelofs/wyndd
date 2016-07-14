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
      name = "Sacrifice a bull",
      options = {
        {
          name = "These blessings are worth more than a bull",
          needs = {{"might"}},
          gains = {{"standing", "priests", 1}, {"standing", "peasants", -1}},
        },
        {
          name = "Let the priests find some other creature.",
          needs = {{"official"}},
          gains = {{"standing", "priests", -1}, {"standing", "peasants", 1}},
        }
      },
      default = {
        name = "Let them fight it out",
        gains = {{"standing", "priests", -1}, {"standing", "peasants", -1}},
      }            
    },
    validator = { "seasonal", "autumn" },
    faction = "priests"
  }, 
  {
    identifier = "priests_blessing",
    issue = {
      type = "opportunity",
      name = "Give blessing",
      options = {
        {
          name = "Let them give their blessings",
          needs = { {"faith"}},
          gains = {{"score", 1}},
        }
      },
      default = {
        name = "We don't have time for this nonsense.",
        gains = {},
      }
    },
    validator = {"always"},
    faction = "priests"
  }, 
}

return potentials